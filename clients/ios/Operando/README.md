<h1><a id="PlusPrivacy_iOS_App_0"></a>PlusPrivacy iOS App</h1>
<p>In order to build PlusPrivacy for iOS, the following requirements need to be satisfied:</p>
<ul>
<li>1.OS: OS X 10.12</li>
<li>2.Build Environment: Xcode v8.2</li>
</ul>
<p>Pull the ‘PlusPrivacy’ repository, and then switch to the ‘master’ branch. Assuming you have been given access, the repository is located at <a href="https://github.com/OPERANDOH2020/PlusPrivacy/">https://github.com/OPERANDOH2020/PlusPrivacy/</a></p>
<p>Navigate to “PlusPrivacy/clients/ios/Operando” and double-click to open the file Operando.xcodeproj<br>
You can now run the app in the simulator with the full functionality. See <a href="https://youtu.be/dITD5UhSf1w">https://youtu.be/dITD5UhSf1w</a>.</p>
<p>At the moment there is no official way to make an adhoc build without being part of a developer team, which registered the app’s bundle id and created an Adhoc provisioning profile.</p>
<p>You would need to have an account and be registered in that development team, such as:<br>
email:  <a href="mailto:l2652150@mvrht.com">l2652150@mvrht.com</a><br>
password:  PPdevaccount123<br>
(Note: This account is used only for the purpose of the video demonstration)</p>
<p>You can add an account by going to Xcode (top-Left menu item) -&gt; Preferences -&gt; Accounts<br>
Click the + button, select “Add Apple ID” and then copy and paste the credentials and confirm.</p>
<p>If not selected, select ( by clicking ) the top-most item on the list view on the left, named “PlusPrivacy” ( with a blue icon on the left ).<br>
On the right panel, select “Operando”, the first under the “TARGETS” section. The panel right to it should update.</p>
<p>There should be 3 sections present: “Signing”, “Signing (Debug)”, “Signing (Release)”.</p>
<ul>
<li>For “Release” do the following: from “Provisioning Profile” select an adhoc provisioning profile ( Xcode downloads these automatically, in the video example it is called “OperandoAdHoc”).</li>
<li>For “Debug” leave it as is. ( App debugging is not covered in this document)</li>
</ul>
<p>Press “alt + CMD + R”. This will bring up a window with a list on the left, from which you will select “Archive” and then press the “Archive” button on the bottom-right. Make sure the “Reveal Archive in Organizer” checkbox is checked.</p>
<p>Xcode will compile and generate an archive (this process should take around 10 - 30 seconds) and then a new window should automatically pop-up.</p>
<p>With everything selected as-is, press the “Export” button on the right panel:</p>
<ul>
<li>Choose “Save for AdHoc deployment”, click “Next”.</li>
<li>Choose your development team ( in the video example this is called “ROMSOFT SRL” ) from the development teams list.</li>
<li>Select “Export one app for all compatible devices”, click “Next”.</li>
<li>Select the location where the folder containing the .ipa file will be created, “Export”</li>
</ul>
<p>The .ipa is ready to be installed on the device. You can use tools such as iFunBox or iMazing, but a simpler way to do it is this:</p>
<ol>
<li>Go to <a href="http://www.diawi.com">www.diawi.com</a></li>
<li>Upload the .ipa</li>
<li>A link will be generated. Access this link on the device using Safari.</li>
</ol>
<p>The .ipa can be installed only on the devices registered in the provisioning profile.<br>
You will find a video demonstration of the process here <a href="https://youtu.be/YPb0lvwrnlY">https://youtu.be/YPb0lvwrnlY</a>.</p>