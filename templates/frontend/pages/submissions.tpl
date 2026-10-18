{**
 * Audhighasu — submissions
 * Author  : Edi Suherlan | audhighasu.com
 *}
{assign var="isFullWidth" value=true}
{include file="frontend/components/header.tpl" pageTitle="about.submissions"}

<div class="page page_submissions ah-page">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="about.submissions"}
	{include file="frontend/components/pageIntro.tpl" ahKickerKey="plugins.themes.audhighasu.submissions.kicker" ahTitleKey="about.submissions" ahLeadKey="plugins.themes.audhighasu.submissions.lead"}

	{if $currentContext->getLocalizedData('authorGuidelines')}
		<div class="ah-panel ah-prose">
			<h2 class="ah-panel__title">{translate key="about.authorGuidelines"}</h2>
			{include file="frontend/components/editLink.tpl" page="management" op="settings" path="workflow" anchor="submission" sectionTitleKey="about.authorGuidelines"}
			{$currentContext->getLocalizedData('authorGuidelines')}
		</div>
	{/if}

	{if $submissionChecklist}
		<div class="ah-panel">
			<h2 class="ah-panel__title">{translate key="about.submissionPreparationChecklist"}</h2>
			{include file="frontend/components/editLink.tpl" page="management" op="settings" path="workflow" anchor="submission" sectionTitleKey="about.submissionPreparationChecklist"}
			{$submissionChecklist}
		</div>
	{/if}

	{if $currentContext->getLocalizedData('copyrightNotice')}
		<div class="ah-panel ah-prose">
			<h2 class="ah-panel__title">{translate key="about.copyrightNotice"}</h2>
			{include file="frontend/components/editLink.tpl" page="management" op="settings" path="workflow" anchor="submission" sectionTitleKey="about.copyrightNotice"}
			{$currentContext->getLocalizedData('copyrightNotice')}
		</div>
	{/if}

	<div class="ah-page__cta">
		{if $currentUser}
			<a class="ah-btn ah-btn--solid" href="{url page="submission"}">{translate key="plugins.themes.audhighasu.masthead.submit"}</a>
		{else}
			<a class="ah-btn ah-btn--solid" href="{url page="login"}">{translate key="user.login"}</a>
			<a class="ah-btn ah-btn--ghost" href="{url page="user" op="register"}">{translate key="user.register"}</a>
		{/if}
	</div>
</div>

{include file="frontend/components/footer.tpl"}
