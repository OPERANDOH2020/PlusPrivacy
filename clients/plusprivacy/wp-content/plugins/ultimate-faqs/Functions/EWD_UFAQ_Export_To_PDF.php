<?php
function EWD_UFAQ_Export_To_PDF() {
		require_once(EWD_UFAQ_CD_PLUGIN_PATH . '/FPDF/fpdf.php');
		
		if ($Category != "EWD_UFAQ_ALL_CATEGORIES") {
			$category_array = array( 
				'taxonomy' => 'ufaq-category',
				'field' => 'slug',
				'terms' => $Category->slug
			);
		}

		$params = array(
			'posts_per_page' => -1,
			'post_type' => 'ufaq'
		);
		$faqs = get_posts($params);

		$PDFPasses = array("FirstPageRun", "SecondPageRun", "Final");
		foreach ($PDFPasses as $PDFRun) {
				$pdf = new FPDF();
				$pdf->AddPage();

				if ($PDFRun == "SecondPageRun" or $PDFRun == "Final") {
					  $pdf->SetFont('Arial','B',14);
						$pdf->Cell(20, 10, "Page #");
						$pdf->Cell(20, 10, "Article Title");
						$pdf->Ln();
						$pdf->SetFont('Arial','',12);

						foreach ($ToC as $entry) {
								$pdf->Cell(20, 5, "  " . utf8_decode($entry['page']));
								$pdf->MultiCell(0, 5, utf8_decode($entry['title']));
								$pdf->Ln();
						}

						unset($ToC);
				}

				foreach ($faqs as $faq) {
						$PostTitle = utf8_decode(strip_tags(html_entity_decode($faq->post_title)));

						$PostText = utf8_decode(strip_tags(html_entity_decode($faq->post_content)));
						$PostText = str_replace("&#91;", "[", $PostText);
						$PostText = str_replace("&#93;", "]", $PostText);

						$pdf->AddPage();

						$Entry['page'] = $pdf->page;
						$Entry['title'] = $PostTitle;

						$pdf->SetFont('Arial','B',15);
						$pdf->MultiCell(0, 10, $PostTitle);
						$pdf->Ln();
						$pdf->SetFont('Arial','',12);
						$pdf->MultiCell(0, 10, $PostText);

						$ToC[] = $Entry;
						unset($Entry);
				}

				if ($PDFRun == "FirstPageRun" or $PDFRun == "SecondPageRun") {
					  $pdf->Close();
				}

				if ($PDFRun == "Final") {
		 			  $pdf->Output('Ultimate-FAQ-Manual.pdf', 'D');
				}
		}
}
?>
