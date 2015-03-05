Wizard data values:
{foreach key="k" item="v" from="$WIZ"}
	+ Page #{$k/}
	{foreach key="pk" item="pv" from="$v"}- {$pk/}={$pv/}
	{/foreach}
{/foreach}
