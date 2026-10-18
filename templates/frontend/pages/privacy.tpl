{**
 * Audhighasu — privacy
 * Author  : Edi Suherlan | audhighasu.com
 *}
{assign var="isFullWidth" value=true}
{include file="frontend/components/header.tpl" pageTitle="about.privacyStatement"}

<div class="page page_privacy ah-page">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="about.privacyStatement"}
	{include file="frontend/components/pageIntro.tpl" ahKickerKey="plugins.themes.audhighasu.privacy.kicker" ahTitleKey="about.privacyStatement" ahLeadKey="plugins.themes.audhighasu.privacy.lead"}
	{include file="frontend/components/editLink.tpl" page="management" op="settings" path="website" anchor="privacy" sectionTitleKey="about.privacyStatement"}
	<div class="ah-panel ah-prose">
		{$currentContext->getLocalizedData('privacyStatement')}
	</div>
</div>

{include file="frontend/components/footer.tpl"}
