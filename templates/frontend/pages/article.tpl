{**
 * Audhighasu — article page
 * Author  : Edi Suherlan | audhighasu.com
*}
{assign var="isFullWidth" value=true}
{include file="frontend/components/header.tpl" pageTitleTranslated=$article->getCurrentPublication()->getLocalizedFullTitle(null, 'html')|strip_unsafe_html}

<div class="page page_article ah-page ah-article">
	{if $section}
		{include file="frontend/components/breadcrumbs_article.tpl" currentTitle=$section->getLocalizedTitle()}
	{else}
		{include file="frontend/components/breadcrumbs_article.tpl" currentTitleKey="common.publication"}
	{/if}

	<p class="ah-article__kicker ah-kicker">
		{translate key="plugins.themes.audhighasu.article.kicker"}
		{if $issue}
			· Vol {$issue->getVolume()|escape} No {$issue->getNumber()|escape} ({$issue->getYear()|escape})
		{/if}
	</p>

	{include file="frontend/objects/article_details.tpl"}

	{call_hook name="Templates::Article::Footer::PageFooter"}
</div>

{include file="frontend/components/footer.tpl"}
