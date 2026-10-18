{**
 * Audhighasu — article details (Research Folio layout)
 * Author  : Edi Suherlan | audhighasu.com
*}
{if !$heading}
	{assign var="heading" value="h3"}
{/if}

<article class="obj_article_details ah-article-details">

	{if $publication->getData('status') !== PKP\submission\PKPSubmission::STATUS_PUBLISHED}
		<div class="cmp_notification notice">
			{capture assign="submissionUrl"}{url page="dashboard" op="editorial" workflowSubmissionId=$article->getId()}{/capture}
			{translate key="submission.viewingPreview" url=$submissionUrl}
		</div>
	{elseif $currentPublication->getId() !== $publication->getId()}
		<div class="cmp_notification notice">
			{capture assign="latestVersionUrl"}{url page="article" op="view" path=$article->getBestId()}{/capture}
			{translate key="submission.outdatedVersion"
				datePublished=$publication->getData('datePublished')|date_format:$dateFormatShort
				urlRecentVersion=$latestVersionUrl|escape
			}
		</div>
	{/if}

	<header class="ah-article-head">
		<div class="ah-article-head__glow" aria-hidden="true"></div>
		<h1 class="page_title ah-article-head__title">
			{$publication->getLocalizedTitle(null, 'html')|strip_unsafe_html}
		</h1>
		{if $publication->getLocalizedData('subtitle')}
			<h2 class="subtitle ah-article-head__subtitle">
				{$publication->getLocalizedSubTitle(null, 'html')|strip_unsafe_html}
			</h2>
		{/if}

		{if $publication->getData('authors')}
			<section class="item authors ah-article-authors">
				<h2 class="pkp_screen_reader">{translate key="article.authors"}</h2>
				<ul class="authors">
				{foreach from=$publication->getData('authors') item=author}
					<li>
						<span class="name">{$author->getFullName()|escape}</span>
						{if count($author->getAffiliations()) > 0}
							<span class="affiliation">
								{assign var="renderedAffiliation" value=false}
								{foreach from=$author->getAffiliations() item="affiliation"}
									{if $affiliation->getLocalizedName() || $affiliation->getRor()}
										{if $renderedAffiliation}{translate key="common.commaListSeparator"}{/if}
										{if $affiliation->getLocalizedName()}<span>{$affiliation->getLocalizedName()|escape}</span>{/if}
										{if $affiliation->getRor()}<a href="{$affiliation->getRor()|escape}">{$rorIdIcon}</a>{/if}
										{assign var="renderedAffiliation" value=true}
									{/if}
								{/foreach}
							</span>
						{/if}
						{assign var=authorUserGroup value=$userGroupsById[$author->getData('userGroupId')]}
						{if $authorUserGroup->showTitle}
							<span class="userGroup">{$authorUserGroup->getLocalizedData('name')|escape}</span>
						{/if}
						{if $author->getData('orcid')}
							<span class="orcid">
								{if $author->hasVerifiedOrcid()}{$orcidIcon}{else}{$orcidUnauthenticatedIcon}{/if}
								<a href="{$author->getData('orcid')|escape}" target="_blank" rel="noopener noreferrer">
									{$author->getOrcidDisplayValue()|escape}
								</a>
							</span>
						{/if}
					</li>
				{/foreach}
				</ul>
			</section>
		{/if}
	</header>

	<div class="ah-article-layout">
		<div class="ah-article-body">

			{assign var=doiObject value=$article->getCurrentPublication()->getData('doiObject')}
			{if $doiObject}
				{assign var="doiUrl" value=$doiObject->getData('resolvingUrl')|escape}
				<section class="item doi">
					<h2 class="label">
						{capture assign=translatedDOI}{translate key="doi.readerDisplayName"}{/capture}
						{translate key="semicolon" label=$translatedDOI}
					</h2>
					<span class="value"><a href="{$doiUrl}">{$doiUrl}</a></span>
				</section>
			{/if}

			{if !empty($publication->getLocalizedData('keywords'))}
				<section class="item keywords">
					<h2 class="label">
						{capture assign=translatedKeywords}{translate key="article.subject"}{/capture}
						{translate key="semicolon" label=$translatedKeywords}
					</h2>
					<span class="value">
						{foreach name="keywords" from=$publication->getLocalizedData('keywords') item="keyword"}
							<span class="ah-keyword">{$keyword.name|escape}</span>
						{/foreach}
					</span>
				</section>
			{/if}

			{if $publication->getLocalizedData('abstract')}
				<section class="item abstract">
					<h2 class="label">{translate key="article.abstract"}</h2>
					{$publication->getLocalizedData('abstract')|strip_unsafe_html}
				</section>
			{/if}

			{call_hook name="Templates::Article::Main"}

			{include file="frontend/components/articleStats.tpl"}

			{assign var="hasBiographies" value=0}
			{foreach from=$publication->getData('authors') item=author}
				{if $author->getLocalizedData('biography')}
					{assign var="hasBiographies" value=$hasBiographies+1}
				{/if}
			{/foreach}
			{if $hasBiographies}
				<section class="item author_bios">
					<h2 class="label">
						{if $hasBiographies > 1}
							{translate key="submission.authorBiographies"}
						{else}
							{translate key="submission.authorBiography"}
						{/if}
					</h2>
					<ul class="authors">
					{foreach from=$publication->getData('authors') item=author}
						{if $author->getLocalizedData('biography')}
							<li class="sub_item">
								<div class="label">
									{if $author->getLocalizedAffiliationNamesAsString()}
										{capture assign="authorName"}{$author->getFullName()|escape}{/capture}
										{capture assign="authorAffiliations"} {$author->getLocalizedAffiliationNamesAsString(null, ', ')|escape} {/capture}
										{translate key="submission.authorWithAffiliation" name=$authorName affiliation=$authorAffiliations}
									{else}
										{$author->getFullName()|escape}
									{/if}
								</div>
								<div class="value">{$author->getLocalizedData('biography')|strip_unsafe_html}</div>
							</li>
						{/if}
					{/foreach}
					</ul>
				</section>
			{/if}

			{if count($parsedCitations) || (string) $publication->getData('citationsRaw')}
				<section class="item references">
					<h2 class="label">{translate key="submission.citations"}</h2>
					<div class="value">
						{if count($parsedCitations)}
							{foreach from=$parsedCitations item="parsedCitation"}
								<p>{$parsedCitation->getCitationWithLinks()|strip_unsafe_html} {call_hook name="Templates::Article::Details::Reference" citation=$parsedCitation}</p>
							{/foreach}
						{else}
							{$publication->getData('citationsRaw')|escape|nl2br}
						{/if}
					</div>
				</section>
			{/if}
		</div>

		<aside class="ah-article-aside">
			{if $publication->getLocalizedData('coverImage') || ($issue && $issue->getLocalizedCoverImage())}
				<div class="item cover_image ah-article-aside__cover">
					{if $publication->getLocalizedData('coverImage')}
						{assign var="coverImage" value=$publication->getLocalizedData('coverImage')}
						<img
							src="{$publication->getLocalizedCoverImageUrl($article->getData('contextId'))|escape}"
							alt="{$coverImage.altText|escape|default:''}"
							loading="lazy"
						>
					{else}
						<a href="{url page="issue" op="view" path=$issue->getBestIssueId()}">
							<img
								src="{$issue->getLocalizedCoverImageUrl()|escape}"
								alt="{$issue->getLocalizedCoverImageAltText()|escape|default:''}"
								loading="lazy"
							>
						</a>
					{/if}
				</div>
			{/if}

			{if $primaryGalleys}
				<div class="item galleys">
					<h2 class="label">{translate key="submission.downloads"}</h2>
					<ul class="value galleys_links">
						{foreach from=$primaryGalleys item=galley}
							<li>
								{include file="frontend/objects/galley_link.tpl" parent=$article publication=$publication galley=$galley purchaseFee=$currentJournal->getData('purchaseArticleFee') purchaseCurrency=$currentJournal->getData('currency')}
							</li>
						{/foreach}
					</ul>
				</div>
			{/if}
			{if $supplementaryGalleys}
				<div class="item galleys">
					<h3 class="label">{translate key="submission.additionalFiles"}</h3>
					<ul class="value supplementary_galleys_links">
						{foreach from=$supplementaryGalleys item=galley}
							<li>
								{include file="frontend/objects/galley_link.tpl" parent=$article publication=$publication galley=$galley isSupplementary="1"}
							</li>
						{/foreach}
					</ul>
				</div>
			{/if}

			{if $publication->getData('datePublished')}
				<div class="item published">
					<section class="sub_item">
						<h2 class="label">{translate key="submissions.published"}</h2>
						<div class="value">
							{if $firstPublication->getId() === $publication->getId()}
								<span>{$firstPublication->getData('datePublished')|date_format:$dateFormatShort}</span>
							{else}
								<span>{translate key="submission.updatedOn" datePublished=$firstPublication->getData('datePublished')|date_format:$dateFormatShort dateUpdated=$publication->getData('datePublished')|date_format:$dateFormatShort}</span>
							{/if}
						</div>
					</section>
					{if count($article->getPublishedPublications()) > 1}
						<section class="sub_item versions">
							<h2 class="label">{translate key="submission.versions"}</h2>
							<ul class="value">
								{foreach from=array_reverse($article->getPublishedPublications()) item=iPublication}
									{capture assign="name"}{translate key="submission.versionIdentity" datePublished=$iPublication->getData('datePublished')|date_format:$dateFormatShort version=$iPublication->getData('version')}{/capture}
									<li>
										{if $iPublication->getId() === $publication->getId()}
											{$name}
										{elseif $iPublication->getId() === $currentPublication->getId()}
											<a href="{url page="article" op="view" path=$article->getBestId()}">{$name}</a>
										{else}
											<a href="{url page="article" op="view" path=$article->getBestId()|to_array:"version":$iPublication->getId()}">{$name}</a>
										{/if}
									</li>
								{/foreach}
							</ul>
						</section>
					{/if}
				</div>
			{/if}

			{if $issue || $section || $categories}
				<div class="item issue">
					{if $issue}
						<section class="sub_item">
							<h2 class="label">{translate key="issue.issue"}</h2>
							<div class="value">
								<a class="title" href="{url page="issue" op="view" path=$issue->getBestIssueId()}">
									{$issue->getIssueIdentification()|escape}
								</a>
							</div>
						</section>
					{/if}
					{if $section}
						<section class="sub_item">
							<h2 class="label">{translate key="section.section"}</h2>
							<div class="value">{$section->getLocalizedTitle()|escape}</div>
						</section>
					{/if}
					{if $categories}
						<section class="sub_item">
							<h2 class="label">{translate key="category.category"}</h2>
							<div class="value">
								<ul class="categories">
									{foreach from=$categories item=category}
										<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="catalog" op="category" path=$category->getPath()|escape}">{$category->getLocalizedTitle()|escape}</a></li>
									{/foreach}
								</ul>
							</div>
						</section>
					{/if}
				</div>
			{/if}

			{foreach from=$pubIdPlugins item=pubIdPlugin}
				{if $pubIdPlugin->getPubIdType() == 'doi'}{continue}{/if}
				{assign var=pubId value=$publication->getStoredPubId($pubIdPlugin->getPubIdType())}
				{if $pubId}
					<section class="item pubid">
						<h2 class="label">{$pubIdPlugin->getPubIdDisplayType()|escape}</h2>
						<div class="value">
							{if $pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
								<a href="{$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}">
									{$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
								</a>
							{else}
								{$pubId|escape}
							{/if}
						</div>
					</section>
				{/if}
			{/foreach}

			{if $currentContext->getLocalizedData('licenseTerms') || $publication->getData('licenseUrl')}
				<div class="item copyright">
					<h2 class="label">{translate key="submission.license"}</h2>
					{if $publication->getData('licenseUrl')}
						{if $ccLicenseBadge}
							{if $publication->getLocalizedData('copyrightHolder')}
								<p>{translate key="submission.copyrightStatement" copyrightHolder=$publication->getLocalizedData('copyrightHolder') copyrightYear=$publication->getData('copyrightYear')}</p>
							{/if}
							{$ccLicenseBadge}
						{else}
							<a href="{$publication->getData('licenseUrl')|escape}" class="copyright">
								{if $publication->getLocalizedData('copyrightHolder')}
									{translate key="submission.copyrightStatement" copyrightHolder=$publication->getLocalizedData('copyrightHolder') copyrightYear=$publication->getData('copyrightYear')}
								{else}
									{translate key="submission.license"}
								{/if}
							</a>
						{/if}
					{/if}
					{$currentContext->getLocalizedData('licenseTerms')}
				</div>
			{/if}

			{call_hook name="Templates::Article::Details"}
		</aside>
	</div>
</article>
