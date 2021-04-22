// Created by Crowbar 0.71

$modelname "rails/rail_long.mdl"

$staticprop

$bodygroup "Body"
{
	studio "rail_long_lod0.smd"
}

$lod 100
{
	replacemodel "rail_long_lod0.smd" "rail_long_lod0_lod1.smd"
	nofacial
}

$surfaceprop "metal"

$contents "solid"

$illumposition 0 -0.024 7.659

$cdmaterials "models\rails\"

$texturegroup "skinfamilies"
{
	{ "rails1" }
	{ "rails3" }
}

$cbox 0 0 0 0 0 0

$bbox -319.885 -132.416 -18.826 319.942 132.416 34.143

$definebone "static_prop" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "idle" {
	"rail_long_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "rail_long_physics.smd"
{
	$mass 1
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "
	$concave
	$maxconvexpieces 13

}
