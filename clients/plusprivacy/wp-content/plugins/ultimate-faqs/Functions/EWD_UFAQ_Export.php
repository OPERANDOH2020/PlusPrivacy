<?php
function EWD_UFAQ_Export_To_PDF() {
		require_once(EWD_UFAQ_CD_PLUGIN_PATH . '/FPDF/fpdf.php');
		global $Category; /*Undefined Category variable at line 5 and 7*/
		// if ($Category != "EWD_UFAQ_ALL_CATEGORIES") {$category_array = array( 'taxonomy' => 'ufaq-category',
		// 																																			'field' => 'slug',
		// 																																			'terms' => $Category->slug
		// 																																		  );
		//
		// }

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
								$pdf->Cell(20, 5, "  " . $entry['page']);
								$pdf->MultiCell(0, 5, $entry['title']);
								$pdf->Ln();
						}

						unset($ToC);
				}

				foreach ($faqs as $faq) {
						$PostTitle = strip_tags(html_entity_decode($faq->post_title));

						$PostText = strip_tags(html_entity_decode($faq->post_content));
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

function EWD_UFAQ_Export_To_Excel() {
	$FAQ_Fields_Array = get_option("EWD_UFAQ_FAQ_Fields");
	if (!is_array($FAQ_Fields_Array)) {$FAQ_Fields_Array = array();}

	include_once('../wp-content/plugins/ultimate-faqs/PHPExcel/Classes/PHPExcel.php');

		// Instantiate a new PHPExcel object
		$objPHPExcel = new PHPExcel();
		// Set the active Excel worksheet to sheet 0
		$objPHPExcel->setActiveSheetIndex(0);

		// Print out the regular order field labels
		$objPHPExcel->getActiveSheet()->setCellValue("A1", "Question");
		$objPHPExcel->getActiveSheet()->setCellValue("B1", "Answer");
		$objPHPExcel->getActiveSheet()->setCellValue("C1", "Categories");
		$objPHPExcel->getActiveSheet()->setCellValue("D1", "Tags");
		$objPHPExcel->getActiveSheet()->setCellValue("E1", "Post Date");

		$column = 'F';
		foreach ($FAQ_Fields_Array as $FAQ_Field_Item) {
     		$objPHPExcel->getActiveSheet()->setCellValue($column."1", $FAQ_Field_Item['FieldName']);
    		$column++;
		}  

		//start while loop to get data
		$rowCount = 2;
		$params = array(
			'posts_per_page' => -1,
			'post_type' => 'ufaq'
		);
		$Posts = get_posts($params);
		foreach ($Posts as $Post)
		{
    	 	$Categories = get_the_terms($Post->ID, "ufaq-category");
			$Category_String = '';
				if (is_array($Categories)) {
    	 		foreach ($Categories  as $Category) {
    	 			$Category_String .= $Category->name . ",";
    	 		}
    	 		$Category_String = substr($Category_String, 0, -1);
    	 	}
    	 	else {$Category_String = "";}

    	 	$Tags = get_the_terms($Post->ID, "ufaq-tag");
    	 	if (is_array($Tags)) {
    	 		foreach ($Tags  as $Tag) {
    	 			$Tag_String .= $Tag->name . ",";
    	 		}
    	 		$Tag_String = substr($Tag_String, 0, -1);
    	 	}
    	 	else {$Tag_String = "";}

    	 	$objPHPExcel->getActiveSheet()->setCellValue("A" . $rowCount, $Post->post_title);
			$objPHPExcel->getActiveSheet()->setCellValue("B" . $rowCount, $Post->post_content);
			$objPHPExcel->getActiveSheet()->setCellValue("C" . $rowCount, $Category_String);
			$objPHPExcel->getActiveSheet()->setCellValue("D" . $rowCount, $Tag_String);
			$objPHPExcel->getActiveSheet()->setCellValue("E" . $rowCount, $Post->post_date);

			$column = 'F';
			foreach ($FAQ_Fields_Array as $FAQ_Field_Item) {
     			$Value = get_post_meta($Post->ID, "Custom_Field_" . $FAQ_Field_Item['FieldID'], true);
     			$objPHPExcel->getActiveSheet()->setCellValue($column . $rowCount, $Value);
    			$column++;
			}  

    		$rowCount++;

    		unset($Category_String);
    		unset($Tag_String);
		}


		// Redirect output to a client’s web browser (Excel5)
		if (!isset($Format_Type) == "CSV") {
			header('Content-Type: application/vnd.ms-excel');
			header('Content-Disposition: attachment;filename="FAQ_Export.csv"');
			header('Cache-Control: max-age=0');
			$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'CSV');
			$objWriter->save('php://output');
		}
		else {
			header('Content-Type: application/vnd.ms-excel');
			header('Content-Disposition: attachment;filename="FAQ_Export.xls"');
			header('Cache-Control: max-age=0');
			$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel5');
			$objWriter->save('php://output');
		}

}
?>
