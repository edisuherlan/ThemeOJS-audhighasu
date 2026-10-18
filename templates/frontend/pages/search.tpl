{**
 * Audhighasu — search
 * Author  : Edi Suherlan | audhighasu.com
*}
{assign var="isFullWidth" value=true}
{include file="frontend/components/header.tpl" pageTitle="common.search"}

{if !$heading}
	{assign var="heading" value="h2"}
{/if}

<div class="page page_search ah-page ah-search">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="common.search"}
	{include file="frontend/components/pageIntro.tpl" ahKickerKey="plugins.themes.audhighasu.search.kicker" ahTitleKey="common.search" ahLeadKey="plugins.themes.audhighasu.search.lead"}

	{capture name="searchFormUrl"}{url escape=false}{/capture}
	{assign var=formUrlParameters value=[]}
	{$smarty.capture.searchFormUrl|parse_url:$smarty.const.PHP_URL_QUERY|default:""|parse_str:$formUrlParameters}

	<form class="cmp_form ah-search-form" method="get" action="{$smarty.capture.searchFormUrl|strtok:"?"|escape}" role="search">
		{foreach from=$formUrlParameters key=paramKey item=paramValue}
			<input type="hidden" name="{$paramKey|escape}" value="{$paramValue|escape}"/>
		{/foreach}

		<div class="ah-search-bar">
			<div class="search_input ah-search-bar__field">
				<label class="pkp_screen_reader" for="query">{translate key="search.searchFor"}</label>
				{block name=searchQuery}
					<input type="search" id="query" name="query" value="{$query|escape}" class="query" placeholder="{translate|escape key="plugins.themes.audhighasu.search.placeholder"}" autocomplete="off" />
				{/block}
			</div>
			<button class="submit ah-btn ah-btn--solid" type="submit">{translate key="common.search"}</button>
		</div>

		<details class="ah-search-filters search_advanced"{if $authors || $dateFromYear || $dateToYear} open{/if}>
			<summary>
				<span>{translate key="search.advancedFilters"}</span>
			</summary>
			<div class="ah-search-filters__grid">
				<div class="from ah-search-field">
					{capture assign="dateFromLegend"}{translate key="search.dateFrom"}{/capture}
					{html_select_date_a11y legend=$dateFromLegend prefix="dateFrom" time=$dateFrom start_year=$yearStart end_year=$yearEnd}
				</div>
				<div class="to ah-search-field">
					{capture assign="dateToLegend"}{translate key="search.dateTo"}{/capture}
					{html_select_date_a11y legend=$dateToLegend prefix="dateTo" time=$dateTo start_year=$yearStart end_year=$yearEnd}
				</div>
				<div class="author ah-search-field">
					<label class="label" for="authors">{translate key="search.author"}</label>
					{block name=searchAuthors}
						<input type="text" id="authors" name="authors" value="{$authors|escape}" placeholder="{translate|escape key="plugins.themes.audhighasu.search.authorPlaceholder"}" />
					{/block}
				</div>
			</div>
		</details>
	</form>

	<section class="ah-search-results" aria-label="{translate|escape key="search.searchResults"}">
		{if !$results->wasEmpty()}
			<p class="ah-search-count" role="status">
				{translate key="plugins.themes.audhighasu.search.found" resultCount=$results->count}
			</p>
			<ul class="search_results ah-toc__articles">
				{iterate from=results item=result}
					<li class="ah-toc__article">
						{include file="frontend/objects/article_summary.tpl" article=$result.publishedSubmission journal=$result.journal showDatePublished=true hideGalleys=true heading="h3"}
					</li>
				{/iterate}
			</ul>
			<div class="cmp_pagination">
				{page_info iterator=$results}
				{page_links anchor="results" iterator=$results name="search" query=$query searchJournal=$searchJournal authors=$authors dateFromMonth=$dateFromMonth dateFromDay=$dateFromDay dateFromYear=$dateFromYear dateToMonth=$dateToMonth dateToDay=$dateToDay dateToYear=$dateToYear}
			</div>
		{else}
			<div class="ah-panel" role="status">
				{if $error}
					{include file="frontend/components/notification.tpl" type="error" message=$error|escape}
				{elseif $query || $authors || $dateFrom || $dateTo}
					<p>{translate key="search.noResults"}</p>
				{else}
					<p>{translate key="plugins.themes.audhighasu.search.idle"}</p>
				{/if}
			</div>
		{/if}
	</section>
</div>

{include file="frontend/components/footer.tpl"}
