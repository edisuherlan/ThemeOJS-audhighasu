{**
 * Audhighasu — about page
 * Author  : Edi Suherlan | audhighasu.com
 *}
{assign var="isFullWidth" value=true}
{include file="frontend/components/header.tpl" pageTitle="about.aboutContext"}

<div class="page page_about ah-page">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="about.aboutContext"}
	{include file="frontend/components/pageIntro.tpl" ahKickerKey="plugins.themes.audhighasu.about.kicker" ahTitleKey="about.aboutContext" ahLeadKey="plugins.themes.audhighasu.about.lead"}
	{include file="frontend/components/editLink.tpl" page="management" op="settings" path="context" anchor="masthead" sectionTitleKey="about.aboutContext"}
	<div class="ah-panel ah-prose">
		{$currentContext->getLocalizedData('about')}
	</div>
</div>

{include file="frontend/components/footer.tpl"}
