MARMOSET SKYSHOP
Image-Based Lighting Tools & Shaders
      by 
Marmoset Co
copyright (c) 2013 Marmoset LLC
support@marmoset.co | http://marmoset.co/skyshop


REQUIREMENTS
Marmoset Skyshop requires Unity Free or Pro, version 4.3.4 or newer.
Marmoset IBL Shaders require Shader Model 3.0 or equivalent.
Mobile shaders have been tested on iOS 6, and Android 4.1.1.

Note: Skyshop includes a custom build of Lightmapping Extended which conflicts with the Asset Store version. Remove any old build of LME from your project before importing.


INSTALLATION 
Import the Skyshop package file into your project. It will contain two top-level folders:
Gizmos/
Marmoset/

Feel free to move the Marmoset/ folders anywhere within your project, but the Gizmos/ folders must remain in the root Assets/ folder of your project (or be merged with the contents of an existing Gizmos/ folder).

To launch Skyshop, click on the Window menu at the top of your screen and find "Skyhsop" from the list.

Taking a closer look inside the Marmoset folder, you will find several sub-categories:
Shaders/ - all Marmoset IBL shaders bundled with Skyshop reside here. Do not re-arrange the contents of the Shaders/ folder.
Skyshop/ - contains all editor and runtime scripts, as well as all the GUI textures needed to run Skyshop.
Docs/ - contains detailed documentation on various Skyshop topics, all as .txt files so you can read them in the Unity Inspector.

If you are more of a learn-by-example type, the Marmoset folder also contains an Examples.zip file, full of useful example scenes, example skies, and art content for you to get started with. The Examples package also includes some handy scripts demonstrating in-game interaction with Skyshop content and skies. Feel free to delete this zip file and all its contents, they are not necessary for Skyshop to function.

You are ready to enjoy Marmoset Skyshop! If you experience problems, feel free to contact us directly at support@marmoset.co.

If you are looking for some panoramic sky content to try out, there are plenty of online resources to tap. Here are some of our staff picks:
http://dativ.at/lightprobes/
http://gl.ict.usc.edu/Data/HighResProbes/
http://www.openfootage.net/?cat=15
http://www.hdri-hub.com/
http://www.hdrlabs.com/sibl/archive.html

Note that not all of the skies you will find online are licensed for commercial use so be mindful of downloading skies you may eventually wish to ship with a commercial game. Quality light-probes are not easy to make, and our hats are off to the folks who are good at it. --The Marmoset Team

If you are looking to make your own panoramas, Christian Bloch of HDR Labs has written an excellent guide to HDRI photography and digital processing, with walk-throughs of the entire shooting, stitching, and rendering workflow:
"The HDRI Handbook 2.0" - http://www.hdrlabs.com/book/

SHADER FORGE
Skyshop now ships with a set of scripts that adds Skyshop-compatible image-based lighting nodes to Shader Forge. If you have purchased Shader Forge from the asset store, first import it into your project, then expand the Marmoset/ShaderForgeExtension.zip archive in place. It will create a directory under Marmoset/Skyshop/ called Extensions/. When successfully installed, the right-click context menu of nodes in Shader Forge should now contain a "Skyshop" category with diffuse and specular IBL nodes under it.

BETA SHADERS
Skyshop also provides a small sample of the latest, greatest shader research we are doing in-house. These shaders are packaged up in the Marmoset/BetaShaders.zip archive and should be extracted in place (creating a Marmoset/Shader/Beta/ directory). These shaders are subject to future changes or abandonment, and their use in large projects is not advised.

PROPS & LEGAL
The following art assets remain property of their respective owners, and no assumption of ownership is made by Marmoset LLC (they sure are pretty though):
Source content for the "Museum" and "Castle" example panoramas provided by Bernhard Vogl (salzamt@dativ.at, http://dativ.at/lightprobes/).
Source content for the "Pisa" example panorama provided by USC Institute for Creative Technologies (http://gl.ict.usc.edu/).  
Source content for the "Austria" example panorama is provided under the Creative Commons Attribution License; by OpenFootage.net (http://www.openfootage.net).
Source content for the "Stonewall" and "Forest" example panoramas is provided under the Creative Commons Attribution License; by HDRI-Hub.com (http://www.hdri-hub.com).
Source content for the "Shiodome" and "Rooftop" example panoramas is provided under the Creative Commons Attribution Non-Commercial Share Alike 3.0 License; by Christian Bloch (http://www.hdrlabs.com).

Special thanks to Michael Stevenson, the author of Lightmapping Extended, for his help in integrating LME into Skyshop.
Thanks also to Joachim Holmer, author of Shader Forge (http://acegikmo.com/shaderforge), for his help with integration.

