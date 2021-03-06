//Maya ASCII 2014 scene
//Name: EiffelTowerCard.ma
//Last modified: Tue, May 26, 2015 11:36:11 AM
//Codeset: 1252
requires maya "2014";
currentUnit -l centimeter -a degree -t film;
fileInfo "application" "maya";
fileInfo "product" "Maya 2014";
fileInfo "version" "2014";
fileInfo "cutIdentifier" "201310090514-890429";
fileInfo "osv" "Microsoft Windows 8 Business Edition, 64-bit  (Build 9200)\n";
createNode transform -n "EiffellTower";
createNode mesh -n "EiffellTowerShape" -p "EiffellTower";
	setAttr -k off ".v";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
createNode transformGeometry -n "transformGeometry28";
	setAttr ".txf" -type "matrix" 44353.307913424869 0 0 0 0 -1.969682546550938e-011 44353.307913424869 0
		 0 -44353.307913424869 -1.969682546550938e-011 0 -22176.653956712435 22176.653956712435 1.4772619099132036e-011 1;
createNode polyPlane -n "polyPlane2";
	setAttr ".sw" 1;
	setAttr ".sh" 1;
	setAttr ".cuv" 2;
createNode materialInfo -n "materialInfo15";
createNode shadingEngine -n "blinn14SG";
	setAttr ".ihi" 0;
	setAttr ".ro" yes;
createNode blinn -n "blinn14";
createNode file -n "EiffelTower_DIFFwAlpha_1";
	setAttr ".ftn" -type "string" "F:/Maya_Assets/Environments/Volcano//sourceimages/EiffelTower_DIFFwAlpha.png";
createNode place2dTexture -n "place2dTexture19";
createNode lightLinker -s -n "lightLinker1";
	setAttr -s 19 ".lnk";
	setAttr -s 19 ".slnk";
select -ne :time1;
	setAttr ".o" 1;
	setAttr ".unw" 1;
select -ne :renderPartition;
	setAttr -s 19 ".st";
select -ne :initialShadingGroup;
	setAttr -s 3 ".dsm";
	setAttr ".ro" yes;
select -ne :initialParticleSE;
	setAttr ".ro" yes;
select -ne :defaultShaderList1;
	setAttr -s 19 ".s";
select -ne :defaultTextureList1;
	setAttr -s 22 ".tx";
select -ne :lightList1;
	setAttr -s 3 ".l";
select -ne :postProcessList1;
	setAttr -s 2 ".p";
select -ne :defaultRenderUtilityList1;
	setAttr -s 23 ".u";
select -ne :defaultRenderingList1;
select -ne :renderGlobalsList1;
select -ne :defaultRenderGlobals;
	setAttr ".ren" -type "string" "mayaHardware2";
select -ne :defaultResolution;
	setAttr ".pa" 1;
select -ne :defaultLightSet;
	setAttr -s 3 ".dsm";
select -ne :hardwareRenderGlobals;
	setAttr ".ctrs" 256;
	setAttr ".btrs" 512;
select -ne :hardwareRenderingGlobals;
	setAttr ".otfna" -type "stringArray" 18 "NURBS Curves" "NURBS Surfaces" "Polygons" "Subdiv Surfaces" "Particles" "Fluids" "Image Planes" "UI:" "Lights" "Cameras" "Locators" "Joints" "IK Handles" "Deformers" "Motion Trails" "Components" "Misc. UI" "Ornaments"  ;
	setAttr ".otfva" -type "Int32Array" 18 0 1 1 1 1 1
		 1 0 0 0 0 0 0 0 0 0 0 0 ;
	setAttr ".gamm" yes;
select -ne :defaultHardwareRenderGlobals;
	setAttr ".fn" -type "string" "im";
	setAttr ".res" -type "string" "ntsc_4d 646 485 1.333";
select -ne :ikSystem;
	setAttr -s 4 ".sol";
connectAttr "transformGeometry28.og" "EiffellTowerShape.i";
connectAttr "polyPlane2.out" "transformGeometry28.ig";
connectAttr "blinn14SG.msg" "materialInfo15.sg";
connectAttr "blinn14.msg" "materialInfo15.m";
connectAttr "EiffelTower_DIFFwAlpha_1.msg" "materialInfo15.t" -na;
connectAttr "blinn14.oc" "blinn14SG.ss";
connectAttr "EiffellTowerShape.iog" "blinn14SG.dsm" -na;
connectAttr "EiffelTower_DIFFwAlpha_1.oc" "blinn14.c";
connectAttr "EiffelTower_DIFFwAlpha_1.ot" "blinn14.it";
connectAttr "place2dTexture19.c" "EiffelTower_DIFFwAlpha_1.c";
connectAttr "place2dTexture19.tf" "EiffelTower_DIFFwAlpha_1.tf";
connectAttr "place2dTexture19.rf" "EiffelTower_DIFFwAlpha_1.rf";
connectAttr "place2dTexture19.mu" "EiffelTower_DIFFwAlpha_1.mu";
connectAttr "place2dTexture19.mv" "EiffelTower_DIFFwAlpha_1.mv";
connectAttr "place2dTexture19.s" "EiffelTower_DIFFwAlpha_1.s";
connectAttr "place2dTexture19.wu" "EiffelTower_DIFFwAlpha_1.wu";
connectAttr "place2dTexture19.wv" "EiffelTower_DIFFwAlpha_1.wv";
connectAttr "place2dTexture19.re" "EiffelTower_DIFFwAlpha_1.re";
connectAttr "place2dTexture19.of" "EiffelTower_DIFFwAlpha_1.of";
connectAttr "place2dTexture19.r" "EiffelTower_DIFFwAlpha_1.ro";
connectAttr "place2dTexture19.n" "EiffelTower_DIFFwAlpha_1.n";
connectAttr "place2dTexture19.vt1" "EiffelTower_DIFFwAlpha_1.vt1";
connectAttr "place2dTexture19.vt2" "EiffelTower_DIFFwAlpha_1.vt2";
connectAttr "place2dTexture19.vt3" "EiffelTower_DIFFwAlpha_1.vt3";
connectAttr "place2dTexture19.vc1" "EiffelTower_DIFFwAlpha_1.vc1";
connectAttr "place2dTexture19.o" "EiffelTower_DIFFwAlpha_1.uv";
connectAttr "place2dTexture19.ofs" "EiffelTower_DIFFwAlpha_1.fs";
relationship "link" ":lightLinker1" ":initialShadingGroup.message" ":defaultLightSet.message";
relationship "link" ":lightLinker1" ":initialParticleSE.message" ":defaultLightSet.message";
relationship "link" ":lightLinker1" "blinn14SG.message" ":defaultLightSet.message";
relationship "shadowLink" ":lightLinker1" ":initialShadingGroup.message" ":defaultLightSet.message";
relationship "shadowLink" ":lightLinker1" ":initialParticleSE.message" ":defaultLightSet.message";
relationship "shadowLink" ":lightLinker1" "blinn14SG.message" ":defaultLightSet.message";
connectAttr "blinn14SG.pa" ":renderPartition.st" -na;
connectAttr "blinn14.msg" ":defaultShaderList1.s" -na;
connectAttr "EiffelTower_DIFFwAlpha_1.msg" ":defaultTextureList1.tx" -na;
connectAttr "place2dTexture19.msg" ":defaultRenderUtilityList1.u" -na;
// End of EiffelTowerCard.ma
