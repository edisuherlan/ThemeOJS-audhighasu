{**
 * Audhighasu — issue view
 * Author  : Edi Suherlan | audhighasu.com
*}
{assign var="isFullWidth" value=true}
{include file="frontend/components/header.tpl" pageTitleTranslated=$issueIdentification}

<div class="page page_issue ah-page ah-issue">
	{if !$issue}
		{include file="frontend/components/breadcrumbs_issue.tpl" currentTitleKey="current.noCurrentIssue"}
		{include file="frontend/components/pageIntro.tpl" ahTitleKey="current.noCurrentIssue"}
		{include file="frontend/components/notification.tpl" type="warning" messageKey="current.noCurrentIssueDesc"}
	{else}
		{include file="frontend/components/breadcrumbs_issue.tpl" currentTitle=$issueIdentification}
		{assign var=issueCover value=$issue->getLocalizedCoverImageUrl()}

		<header class="ah-issue__head">
			{if $issueCover}
				<div class="ah-issue__cover">
					<img src="{$issueCover|escape}" alt="{$issue->getLocalizedCoverImageAltText()|escape|default:''}" />
				</div>
			{/if}
			<div class="ah-issue__copy">
				<p class="ah-kicker">{translate key="plugins.themes.audhighasu.issue.kicker"} · {$issue->getYear()|escape}</p>
				<h1 class="ah-issue__title">
					{if $issue->getLocalizedTitle()}
						{$issue->getLocalizedTitle()|escape}
					{else}
						{$issueIdentification|escape}
					{/if}
				</h1>
				<p class="ah-issue__series">
					Vol. {$issue->getVolume()|escape}
					· No. {$issue->getNumber()|escape}
					{if $issue->getDatePublished()}
						· {$issue->getDatePublished()|date_format:$dateFormatLong}
					{/if}
				</p>
				{if $issue->getLocalizedDescription()}
					<div class="ah-issue__desc">{$issue->getLocalizedDescription()|strip_unsafe_html}</div>
				{/if}
			</div>
		</header>

		<div class="ah-issue__toc">
			{include file="frontend/objects/issue_toc.tpl"}
		</div>
	{/if}
</div>

{include file="frontend/components/footer.tpl"}
