{**
 * Audhighasu — issue archive
 * Author  : Edi Suherlan | audhighasu.com
 *}
{capture assign="pageTitle"}
	{if $prevPage}
		{translate key="archive.archivesPageNumber" pageNumber=$prevPage+1}
	{else}
		{translate key="archive.archives"}
	{/if}
{/capture}
{assign var="isFullWidth" value=true}
{include file="frontend/components/header.tpl" pageTitleTranslated=$pageTitle}

<div class="page page_issue_archive ah-page ah-archive">
	{include file="frontend/components/breadcrumbs.tpl" currentTitle=$pageTitle}
	{include file="frontend/components/pageIntro.tpl" ahKickerKey="plugins.themes.audhighasu.archive.kicker" ahTitleTranslated=$pageTitle ahLeadKey="plugins.themes.audhighasu.archive.lead"}

	{if empty($issues)}
		<div class="ah-panel ah-empty" role="status">
			<p>{translate key="current.noCurrentIssueDesc"}</p>
		</div>
	{else}
		<ul class="issues_archive ah-archive__grid">
			{foreach from=$issues item="issue"}
				<li class="ah-archive__item">
					{include file="frontend/objects/issue_summary.tpl"}
				</li>
			{/foreach}
		</ul>

		{if $prevPage > 1}
			{capture assign=prevUrl}{url router=\PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="archive" path=$prevPage}{/capture}
		{elseif $prevPage === 1}
			{capture assign=prevUrl}{url router=\PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="archive"}{/capture}
		{/if}
		{if $nextPage}
			{capture assign=nextUrl}{url router=\PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="archive" path=$nextPage}{/capture}
		{/if}
		{include
			file="frontend/components/pagination.tpl"
			prevUrl=$prevUrl
			nextUrl=$nextUrl
			showingStart=$showingStart
			showingEnd=$showingEnd
			total=$total
		}
	{/if}
</div>

{include file="frontend/components/footer.tpl"}
