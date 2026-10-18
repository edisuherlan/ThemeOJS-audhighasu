{**
 * Audhighasu — shared page intro band
 * Author  : Edi Suherlan | audhighasu.com
 *}
<header class="ah-pageintro">
	<div class="ah-pageintro__ornament" aria-hidden="true">
		<span class="ah-pageintro__glow"></span>
		<span class="ah-pageintro__rule"></span>
	</div>
	{if $ahKickerKey}
		<p class="ah-kicker">{translate key=$ahKickerKey}</p>
	{/if}
	<h1 class="ah-pageintro__title">
		{if $ahTitleTranslated}
			{$ahTitleTranslated|escape}
		{elseif $ahTitleKey}
			{translate key=$ahTitleKey}
		{else}
			{$pageTitleTranslated|escape}
		{/if}
	</h1>
	{if $ahLeadKey}
		<p class="ah-pageintro__lead">{translate key=$ahLeadKey}</p>
	{/if}
</header>
