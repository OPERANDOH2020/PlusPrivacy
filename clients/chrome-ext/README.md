PlusPrivacy Chrome Extension
=========================
PlusPrivacy provides you with a unified dashboard for your internet security and data privacy.

PlusPrivacy is an open source service for protecting yourself from a variety of threats to your privacy online. It will enable you to control the privacy settings in your social network account, hide your email identity, block ads, trackers and malware and prevent unwanted apps and browser extensions from tracking you and collecting your private data.
	Maximizing Privacy On Social Networks
Using PlusPrivacy’s “Single click social network privacy” will set all your privacy preferences to their most privacy-friendly values automatically. You do not need to dig into the privacy settings pages of each of your social network account (eg. Google, Facebook, Twitter, LinkedIn). PlusPrivacy dashboard is all you need.
	Browser Extensions and Connected Apps
One of the coolest features of PlusPrivacy dashboard is automated discovery of apps connected to your Facebook, Twitter, Google, LinkedIn and Dropbox accounts, as well as extensions installed in your Chrome browser, and a single click termination of access (or un-installation) of those of them that you no longer want to access your data. In most cases PlusPrivacy will also tell you what are the exact permissions given to a connected app. All this will be presented to you in a table with a disable/uninstall button next to each app- giving you the ability to take a single click action. Even if you have tens of unwanted apps connected to your social network accounts, you will be done in 2 minutes!
	My Identities
If you want to secure your email use email identity management. Sing up/log in with your email address, which will then be used by PlusPrivacy servers for the sole purpose of re-mailing your email to hide your identity. You will be able to send anonymous email and the sender will not know your real email address.
PlusPrivacy offers identity theft protection by allowing you to create up to 20 fake email identities, which will let you to hide your identity from websites and individuals. From now on you can do anonymous surfing on the internet without to be worry about your online privacy.
	Ad Blocking & Anti-Tracking
PlusPrivacy’s ad blocker is based on open sources code of and block cookies, blocks video ads, banners, pop-ups and other forms of intrusive and annoying advertising, as well as blocking online tracking and malware.
What distinguishes PlusPrivacy ad blocking from others ad blockers is that there are no “Acceptable Ads”, all ads and trackers are blocked by default.
	Consent Deals
Do your own privacy-for-benefit deals!
PlusPrivacy will help you to trade your privacy for rewards and benefits offered by participating service providers.
Take back your privacy!

Building the extension
----------------------

### Requirements
- [NodeJs](https://nodejs.org)
### Preparing build environment
Change working directory to PlusPrivacy/clients/chrome-ext and run

    npm install
### Building the extension for development environment
    grunt
A localhost server is needed. For installing a PlusPrivacy server please see
### Building the extension for release/testing environment
    grunt release
    //or
    grunt test

After the build process finishes, the working directory should contain the following directory:
    - dist
Drag and drop it in Chrome -> More tools -> Extensions to install it.