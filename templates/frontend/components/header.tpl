{**
 * Audhighasu — orange research-folio masthead
 * Author  : Edi Suherlan | audhighasu.com
*}
{strip}
	{assign var="showingLogo" value=true}
	{if !$displayPageHeaderLogo}
		{assign var="showingLogo" value=false}
	{/if}
{/strip}
<!DOCTYPE html>
<html lang="{$currentLocale|replace:"_":"-"}" xml:lang="{$currentLocale|replace:"_":"-"}">
{if !$pageTitleTranslated}{capture assign="pageTitleTranslated"}{translate key=$pageTitle}{/capture}{/if}
{include file="frontend/components/headerHead.tpl"}
<body class="pkp_page_{$requestedPage|escape|default:"index"} pkp_op_{$requestedOp|escape|default:"index"}{if $showingLogo} has_site_logo{/if} ah-theme" dir="{$currentLocaleLangDir|escape|default:"ltr"}">

	<div class="pkp_structure_page ah-shell">
		{include file="frontend/components/skipLinks.tpl"}

		<div class="ah-imprint" role="presentation">
			<div class="ah-imprint__inner">
				<div class="ah-imprint__left">
					<span class="ah-imprint__badge">{translate key="plugins.themes.audhighasu.imprint.openAccess"}</span>
					<span class="ah-imprint__sep" aria-hidden="true">·</span>
					<span class="ah-imprint__folio">{translate key="plugins.themes.audhighasu.imprint.folio"}</span>
					<span class="ah-imprint__sep ah-imprint__sep--desk" aria-hidden="true">·</span>
					<span class="ah-imprint__promo">
						{if $currentContext}
							{$currentContext->getLocalizedName()|escape}
						{elseif $displayPageHeaderTitle}
							{$displayPageHeaderTitle|escape}
						{else}
							{$siteTitle|escape}
						{/if}
					</span>
				</div>
				<div class="ah-imprint__right">
					{include file="frontend/components/languageToggle.tpl" idPrefix="ahLang"}
					<nav class="ah-imprint__user" aria-label="{translate|escape key="common.navigation.user"}">
						{load_menu name="user" id="navigationUser" ulClass="ah-usernav" liClass="profile"}
					</nav>
				</div>
			</div>
		</div>

		<header class="ah-masthead pkp_structure_head" id="headerNavigationContainer" role="banner">
			<div class="ah-masthead__wash" aria-hidden="true"></div>
			<div class="ah-masthead__inner">
				{capture assign="homeUrl"}{url page="index" router=\PKP\core\PKPApplication::ROUTE_PAGE}{/capture}
				{if !$requestedPage || $requestedPage === 'index'}
					<h1 class="pkp_screen_reader">
						{if $currentContext}{$displayPageHeaderTitle|escape}{else}{$siteTitle|escape}{/if}
					</h1>
				{/if}

				<div class="ah-masthead__brand">
					<span class="ah-masthead__corners" aria-hidden="true"></span>
					{if $displayPageHeaderLogo}
						<a href="{$homeUrl}" class="ah-masthead__logo is_img">
							<img src="{$publicFilesDir}/{$displayPageHeaderLogo.uploadName|escape:"url"}" width="{$displayPageHeaderLogo.width|escape}" height="{$displayPageHeaderLogo.height|escape}" {if $displayPageHeaderLogo.altText != ''}alt="{$displayPageHeaderLogo.altText|escape}"{else}alt=""{/if} />
						</a>
					{/if}
					{if $displayPageHeaderTitle}
						<a href="{$homeUrl}" class="ah-masthead__title">{$displayPageHeaderTitle|escape}</a>
					{elseif !$displayPageHeaderLogo}
						<a href="{$homeUrl}" class="ah-masthead__title">{translate key="common.software"}</a>
					{/if}
					{if $currentContext && $currentContext->getLocalizedData('description')}
						<p class="ah-masthead__deck">{$currentContext->getLocalizedData('description')|strip_tags|truncate:160}</p>
					{/if}
				</div>

				<div class="ah-rule ah-rule--ornate" aria-hidden="true">
					<span class="ah-rule__diamond"></span>
				</div>

				<div class="ah-masthead__bar">
					<button class="ah-nav-toggle" type="button" aria-expanded="false" aria-controls="ahNavPanel" data-ah-nav-toggle>
						<span class="ah-nav-toggle__bars" aria-hidden="true"><span></span><span></span><span></span></span>
						<span class="ah-nav-toggle__label">{translate key="common.navigation.site"}</span>
					</button>

					{* Desktop primary nav — mobile drawer lives outside header stacking context *}
					<nav class="ah-nav ah-nav--desktop" aria-label="{translate|escape key="common.navigation.site"}">
						{load_menu name="primary" id="navigationPrimary" ulClass="ah-nav__list"}
					</nav>

					<div class="ah-masthead__actions">
						{if $currentContext}
							<a class="ah-btn ah-btn--ghost" href="{url page="search"}">{translate key="plugins.themes.audhighasu.masthead.search"}</a>
							<a class="ah-btn ah-btn--solid" href="{url page="about" op="submissions"}">{translate key="plugins.themes.audhighasu.masthead.submit"}</a>
						{/if}
					</div>
				</div>

				{if $currentContext}
					<form class="ah-masthead__search" action="{url page="search"}" method="get" role="search">
						<label class="pkp_screen_reader" for="ahMastQuery">{translate key="common.search"}</label>
						<span class="ah-masthead__search-icon" aria-hidden="true"></span>
						<input id="ahMastQuery" type="search" name="query" placeholder="{translate|escape key="plugins.themes.audhighasu.masthead.searchPlaceholder"}" autocomplete="off" />
						<button type="submit" class="ah-btn ah-btn--solid ah-btn--sm">{translate key="common.search"}</button>
					</form>
				{/if}
			</div>
		</header>

		{* Mobile drawer + backdrop — siblings so backdrop cannot cover links *}
		<div class="ah-nav-backdrop" data-ah-nav-backdrop hidden></div>
		<nav class="ah-nav ah-nav--drawer" id="ahNavPanel" aria-label="{translate|escape key="common.navigation.site"}" aria-hidden="true" hidden>
			<div class="ah-nav__drawer-head">
				<div class="ah-nav__drawer-brand">
					<p class="ah-nav__drawer-kicker">{translate key="plugins.themes.audhighasu.imprint.folio"}</p>
					<strong class="ah-nav__drawer-title">
						{if $currentContext}
							{$currentContext->getLocalizedName()|escape}
						{elseif $displayPageHeaderTitle}
							{$displayPageHeaderTitle|escape}
						{else}
							{$siteTitle|escape}
						{/if}
					</strong>
				</div>
				<button type="button" class="ah-nav__close" data-ah-nav-close aria-label="{translate|escape key="common.close"}">
					<span aria-hidden="true">×</span>
				</button>
			</div>
			{load_menu name="primary" id="navigationPrimaryMobile" ulClass="ah-nav__list"}
			{if $currentContext}
				<div class="ah-nav__drawer-actions">
					<a class="ah-btn ah-btn--ghost" href="{url page="search"}">{translate key="plugins.themes.audhighasu.masthead.search"}</a>
					<a class="ah-btn ah-btn--solid" href="{url page="about" op="submissions"}">{translate key="plugins.themes.audhighasu.masthead.submit"}</a>
				</div>
			{/if}
		</nav>

		<div class="pkp_structure_content ah-content">
			<div class="pkp_structure_main" role="main">
				<a id="pkp_content_main"></a>
