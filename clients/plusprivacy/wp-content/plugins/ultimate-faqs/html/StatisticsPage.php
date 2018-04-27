<?php 
		$Custom_CSS = get_option("EWD_UFAQ_Custom_CSS");
?>
<div class="wrap">
<div id="icon-options-general" class="icon32"><br /></div><h2>Settings</h2>

<form method="post" action="edit.php?post_type=ufaq&page=options&Action=EWD_UFAQ_UpdateOptions">
<table class="form-table">
<tr>
<th scope="row">Custom CSS</th>
<td>
	<fieldset><legend class="screen-reader-text"><span>Custom CSS</span></legend>
	<label title='Custom CSS'></label><textarea class='ewd-ufaq-textarea' name='custom_css'> <?php echo $Custom_CSS; ?></textarea><br />
	<p>You can add custom CSS styles for your FAQs in the box above.</p>
	</fieldset>
</td>
</tr>

<tr>
<th scope="row">FAQ Accordion</th>
<td>
	<fieldset><legend class="screen-reader-text"><span>FAQ Accordion</span></legend>
	<label title='Yes'><input type='radio' name='faq_accordion' value='Yes' <?php if($FAQ_Accordion == "Yes") {echo "checked='checked'";} ?> /> <span>Yes</span></label><br />
	<label title='No'><input type='radio' name='faq_accordion' value='No' <?php if($FAQ_Accordion == "No") {echo "checked='checked'";} ?> /> <span>No</span></label><br />
	<p>Should the FAQs accordion? (Close old open FAQ when a new one is clicked)</p>
	</fieldset>
</td>
</tr>

<tr>
<th scope="row">Reveal Effect</th>
<td>
	<fieldset><legend class="screen-reader-text"><span>Reveal Effect</span></legend>
	<label title='Reveal Effect'></label> 

	<select name="reveal_effect">
  		<option value="none" <?php if($Reveal_Effect == "none") {echo "selected=selected";} ?> >None</option>
			<option value="blind" <?php if($Reveal_Effect == "blind") {echo "selected=selected";} ?> >Blind</option>
  		<option value="bounce" <?php if($Reveal_Effect == "bounce") {echo "selected=selected";} ?> >Bounce</option>
  		<option value="clip" <?php if($Reveal_Effect == "clip") {echo "selected=selected";} ?> >Clip</option>
  		<option value="drop" <?php if($Reveal_Effect == "drop") {echo "selected=selected";} ?> >Drop</option>
  		<option value="explode" <?php if($Reveal_Effect == "explode") {echo "selected=selected";} ?> >Explode</option>
  		<option value="fade" <?php if($Reveal_Effect == "fade") {echo "selected=selected";} ?> >Fade</option>
  		<option value="fold" <?php if($Reveal_Effect == "fold") {echo "selected=selected";} ?> >Fold</option>
  		<option value="highlight" <?php if($Reveal_Effect == "highlight") {echo "selected=selected";} ?> >Highlight</option>
  		<option value="puff" <?php if($Reveal_Effect == "puff") {echo "selected=selected";} ?> >Puff</option>
  		<option value="pulsate" <?php if($Reveal_Effect == "pulsate") {echo "selected=selected";} ?> >Pulsate</option>
  		<option value="shake" <?php if($Reveal_Effect == "shake") {echo "selected=selected";} ?> >Shake</option>
  		<option value="size" <?php if($Reveal_Effect == "size") {echo "selected=selected";} ?> >Size</option>
  		<option value="slide" <?php if($Reveal_Effect == "slide") {echo "selected=selected";} ?> >Slide</option>
	</select>
	
	<p>How should FAQ's be displayed when their titles are clicked?</p>
	</fieldset>
</td>
</tr>
</table>


<p class="submit"><input type="submit" name="Options_Submit" id="submit" class="button button-primary" value="Save Changes"  /></p></form>

</div>