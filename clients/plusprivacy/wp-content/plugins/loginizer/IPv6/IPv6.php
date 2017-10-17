<?php
/* Copyright (c) 2011, Sam Clarke <www.samclarke.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

// Include only if necessary
if(!class_exists('Math_BigInteger')){
	require_once 'BigInteger.php';
}

/**
 * Converts human readable representation to a 128 bit int
 * which can be stored in MySQL using DECIMAL(39,0).
 *
 * Requires PHP to be compiled with IPv6 support.
 * This could be made to work without IPv6 support but
 * I don't think there would be much use for it if PHP
 * doesn't support IPv6.
 *
 * @param string $ip IPv4 or IPv6 address to convert
 * @return string 128 bit string that can be used with DECIMNAL(39,0) or false
 */
if(!function_exists('inet_ptoi'))
{
	function inet_ptoi($ip)
	{
		// make sure it is an ip
		if (filter_var($ip, FILTER_VALIDATE_IP) === false)
			return false;

		$parts = unpack('N*', inet_pton($ip));

		// fix IPv4
		if (strpos($ip, '.') !== false)
			$parts = array(1=>0, 2=>0, 3=>0, 4=>$parts[1]);

		foreach ($parts as &$part)
		{
			// convert any unsigned ints to signed from unpack.
			// this should be OK as it will be a PHP float not an int
			if ($part < 0)
				$part += 4294967296;
		}

		// use BCMath if the extension exists
		if (function_exists('bcadd'))
		{
			$decimal = $parts[4];
			$decimal = bcadd($decimal, bcmul($parts[3], '4294967296'));
			$decimal = bcadd($decimal, bcmul($parts[2], '18446744073709551616'));
			$decimal = bcadd($decimal, bcmul($parts[1], '79228162514264337593543950336'));
		}
		// otherwise use the pure PHP BigInteger
		else
		{
			$decimal = new Math_BigInteger($parts[4]);
			$part3   = new Math_BigInteger($parts[3]);
			$part2   = new Math_BigInteger($parts[2]);
			$part1   = new Math_BigInteger($parts[1]);

			$decimal = $decimal->add($part3->multiply(new Math_BigInteger('4294967296')));
			$decimal = $decimal->add($part2->multiply(new Math_BigInteger('18446744073709551616')));
			$decimal = $decimal->add($part1->multiply(new Math_BigInteger('79228162514264337593543950336')));

			$decimal = $decimal->toString();
		}

		return $decimal;
	}
}

/**
 * Converts a 128 bit int to a human readable representation.
 *
 * Requires PHP to be compiled with IPv6 support.
 * This could be made to work without IPv6 support but
 * I don't think there would be much use for it if PHP
 * doesn't support IPv6.
 *
 * @param string $decimal 128 bit int
 * @return string IPv4 or IPv6
 */
if(!function_exists('inet_itop'))
{
	function inet_itop($decimal)
	{
		$parts = array();

		// use BCMath if the extension exists
		if (function_exists('bcadd'))
		{
			$parts[1] = bcdiv($decimal, '79228162514264337593543950336', 0);
			$decimal  = bcsub($decimal, bcmul($parts[1], '79228162514264337593543950336'));
			$parts[2] = bcdiv($decimal, '18446744073709551616', 0);
			$decimal  = bcsub($decimal, bcmul($parts[2], '18446744073709551616'));
			$parts[3] = bcdiv($decimal, '4294967296', 0);
			$decimal  = bcsub($decimal, bcmul($parts[3], '4294967296'));
			$parts[4] = $decimal;
		}
		// otherwise use the pure PHP BigInteger
		else
		{
			$decimal = new Math_BigInteger($decimal);
			list($parts[1],) = $decimal->divide(new Math_BigInteger('79228162514264337593543950336'));
			$decimal = $decimal->subtract($parts[1]->multiply(new Math_BigInteger('79228162514264337593543950336')));
			list($parts[2],) = $decimal->divide(new Math_BigInteger('18446744073709551616'));
			$decimal = $decimal->subtract($parts[2]->multiply(new Math_BigInteger('18446744073709551616')));
			list($parts[3],) = $decimal->divide(new Math_BigInteger('4294967296'));
			$decimal = $decimal->subtract($parts[3]->multiply(new Math_BigInteger('4294967296')));
			$parts[4] = $decimal;

			$parts[1] = $parts[1]->toString();
			$parts[2] = $parts[2]->toString();
			$parts[3] = $parts[3]->toString();
			$parts[4] = $parts[4]->toString();
		}

		foreach ($parts as &$part)
		{
			// convert any signed ints to unsigned for pack
			// this should be fine as it will be treated as a float
			if ($part > 2147483647)
				$part -= 4294967296;
		}

		$ip = inet_ntop(pack('N4', $parts[1], $parts[2], $parts[3], $parts[4]));

		// fix IPv4 by removing :: from the beginning
		if (strpos($ip, '.') !== false)
			return substr($ip, 2);

		return $ip;
	}
}

// Example
//
// echo inet_ptoi('::FFFF:FFFF:FFFF:FFFF') . "\n";
// echo inet_ptoi('::FFFF:FFFF') . "\n";
// echo inet_ptoi('255.255.255.255') . "\n";
// echo inet_itop(inet_ptoi('::FFFF:FFFF:FFFF:FFFF')) . "\n";
// echo inet_itop(inet_ptoi('::FFFF:FFFF')) . "\n";

/* Output:

18446744073709551615
4294967295
4294967295
::ffff:ffff:ffff:ffff
255.255.255.255
*/
