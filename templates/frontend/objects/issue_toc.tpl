{**
 * Audhighasu — issue TOC
 * Author  : Edi Suherlan | audhighasu.com
 *}
{if !$heading}
	{assign var="heading" value="h2"}
{/if}
{assign var="articleHeading" value="h3"}
{if $heading == "h3"}
	{assign var="articleHeading" value="h4"}
{elseif $heading == "h4"}
	{assign var="articleHeading" value="h5"}
{elseif $heading == "h5"}
	{assign var="articleHeading" value="h6"}
{/if}

<div class="obj_issue_toc ah-toc">
	{if !$issue->getPublished()}
		{include file="frontend/components/notification.tpl" type="warning" messageKey="editor.issues.preview"}
	{/if}

	{if $issueGalleys}
		<div class="galleys ah-toc__galleys">
			<{$heading} id="issueTocGalleyLabel">{translate key="issue.fullIssue"}</{$heading}>
			<ul class="galleys_links">
				{foreach from=$issueGalleys item=galley}
					<li>
						{include file="frontend/objects/galley_link.tpl" parent=$issue labelledBy="issueTocGalleyLabel" purchaseFee=$currentJournal->getData('purchaseIssueFee') purchaseCurrency=$currentJournal->getData('currency')}
					</li>
				{/foreach}
			</ul>
		</div>
	{/if}

	<div class="sections ah-toc__sections">
		{foreach name=sections from=$publishedSubmissions item=section}
			<div class="section ah-toc__section">
				{if $section.articles}
					{if $section.title}
						<{$heading} class="ah-toc__section-title">{$section.title|escape}</{$heading}>
					{else}
						<{$heading} class="ah-toc__section-title">{translate key="plugins.themes.audhighasu.issue.sectionDefault"}</{$heading}>
					{/if}
					<ul class="cmp_article_list articles ah-toc__articles">
						{foreach from=$section.articles item=article}
							<li class="ah-toc__article">
								{include file="frontend/objects/article_summary.tpl" heading=$articleHeading}
							</li>
						{/foreach}
					</ul>
				{/if}
			</div>
		{/foreach}
	</div>
</div>
