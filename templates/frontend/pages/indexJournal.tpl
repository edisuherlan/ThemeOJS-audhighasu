{**
 * Audhighasu — orange Research Folio homepage
 * Author  : Edi Suherlan | audhighasu.com
*}
{assign var="isFullWidth" value=true}
{include file="frontend/components/header.tpl" pageTitleTranslated=$currentJournal->getLocalizedName()}

<div class="page_index_journal ah-home">

	{call_hook name="Templates::Index::journal"}

	{if !$homepageImage && $currentContext}
		{assign var="homepageImage" value=$currentContext->getLocalizedData('homepageImage')}
	{/if}

	<section class="ah-home__hero">
		<div class="ah-home__hero-copy">
			<p class="ah-kicker">{translate key="plugins.themes.audhighasu.home.kicker"}</p>
			<h2 class="ah-home__title">{translate key="plugins.themes.audhighasu.home.title"}</h2>
			<p class="ah-home__lead">
				{if $activeTheme && $activeTheme->getOption('showDescriptionInJournalIndex') && $currentContext->getLocalizedData('description')}
					{$currentContext->getLocalizedData('description')|strip_tags|truncate:240}
				{else}
					{translate key="plugins.themes.audhighasu.home.lead"}
				{/if}
			</p>
			<div class="ah-home__actions">
				<a class="ah-btn ah-btn--solid" href="{url page="about" op="submissions"}">
					{translate key="plugins.themes.audhighasu.masthead.submit"}
				</a>
				<a class="ah-btn ah-btn--ghost" href="{url page="issue" op="current"}">
					{translate key="journal.currentIssue"}
				</a>
			</div>
		</div>
		<div class="ah-home__hero-stats" aria-label="{translate|escape key="plugins.themes.audhighasu.desk.metrics"}">
			<div class="ah-hero-stat">
				<strong>{$ahStats.articles|default:0}</strong>
				<span>{translate key="plugins.themes.audhighasu.stats.articles"}</span>
			</div>
			<div class="ah-hero-stat">
				<strong>{$ahStats.issues|default:0}</strong>
				<span>{translate key="plugins.themes.audhighasu.stats.issues"}</span>
			</div>
			<div class="ah-hero-stat">
				<strong>{$ahStats.authors|default:0}</strong>
				<span>{translate key="plugins.themes.audhighasu.stats.authors"}</span>
			</div>
		</div>
	</section>

	<div class="ah-folio">
		<div class="ah-folio__main">
			<header class="ah-folio__head">
				<p class="ah-kicker">{translate key="plugins.themes.audhighasu.home.listKicker"}</p>
				<h2 class="ah-folio__title">{translate key="plugins.themes.audhighasu.home.listTitle"}</h2>
				<div class="ah-rule ah-rule--short ah-rule--left" aria-hidden="true"><span></span></div>
			</header>

			{if $ahLatestArticles && $ahLatestArticles|@count}
				<ol class="ah-biblio">
					{foreach from=$ahLatestArticles item=article}
						{assign var=publication value=$article->getCurrentPublication()}
						{assign var=pubDate value=$publication->getData('datePublished')}
						<li class="ah-biblio__item">
							<div class="ah-biblio__mark" aria-hidden="true"></div>
							<p class="ah-biblio__authors">
								{foreach from=$publication->getData('authors') item=author name=authors}
									{$author->getFullName()|escape}{if !$smarty.foreach.authors.last}; {/if}
								{/foreach}
							</p>
							{if $pubDate}
								<span class="ah-biblio__year">({$pubDate|date_format:"Y"}).</span>
							{/if}
							<h3 class="ah-biblio__title">
								<a href="{url page="article" op="view" path=$article->getBestId()}">
									{$publication->getLocalizedFullTitle(null, 'html')|strip_unsafe_html}
								</a>
							</h3>
							<a class="ah-biblio__read" href="{url page="article" op="view" path=$article->getBestId()}">
								{translate key="plugins.themes.audhighasu.home.read"} →
							</a>
						</li>
					{/foreach}
				</ol>
			{elseif $currentIssue}
				<div class="ah-empty">
					{include file="frontend/objects/issue_toc.tpl"}
				</div>
			{/if}
		</div>

		<aside class="ah-desk" aria-label="{translate|escape key="plugins.themes.audhighasu.desk.title"}">
			<header class="ah-desk__head">
				<p class="ah-kicker">{translate key="plugins.themes.audhighasu.desk.title"}</p>
				<p class="ah-desk__hint">{translate key="plugins.themes.audhighasu.desk.hint"}</p>
			</header>

			{if $currentIssue}
				<div class="ah-desk__issue">
					<p class="ah-desk__label">{translate key="plugins.themes.audhighasu.desk.current"}</p>
					{if $homepageImage && $homepageImage.uploadName}
						<a class="ah-desk__cover" href="{url page="issue" op="view" path=$currentIssue->getBestIssueId()}">
							<img src="{$publicFilesDir}/{$homepageImage.uploadName|escape:"url"}" alt="" loading="lazy" />
							<span class="ah-desk__cover-badge">{translate key="journal.currentIssue"}</span>
						</a>
					{/if}
					<h3 class="ah-desk__issue-title">
						<a href="{url page="issue" op="view" path=$currentIssue->getBestIssueId()}">
							{$currentIssue->getIssueIdentification()|escape}
						</a>
					</h3>
					{if $currentIssue->getLocalizedDescription()}
						<p class="ah-desk__issue-desc">{$currentIssue->getLocalizedDescription()|strip_tags|truncate:150}</p>
					{/if}
					<a class="ah-btn ah-btn--solid ah-btn--sm" href="{url page="issue" op="view" path=$currentIssue->getBestIssueId()}">
						{translate key="plugins.themes.audhighasu.desk.viewIssue"}
					</a>
				</div>
			{/if}

			<div class="ah-desk__metrics">
				<p class="ah-desk__label">{translate key="plugins.themes.audhighasu.desk.metrics"}</p>
				<ul class="ah-metrics">
					<li>
						<strong>{$ahStats.articles|default:0}</strong>
						<span>{translate key="plugins.themes.audhighasu.stats.articles"}</span>
					</li>
					<li>
						<strong>{$ahStats.issues|default:0}</strong>
						<span>{translate key="plugins.themes.audhighasu.stats.issues"}</span>
					</li>
					<li>
						<strong>{$ahStats.authors|default:0}</strong>
						<span>{translate key="plugins.themes.audhighasu.stats.authors"}</span>
					</li>
				</ul>
				<a class="ah-desk__archive" href="{url page="issue" op="archive"}">
					{translate key="plugins.themes.audhighasu.desk.archive"} →
				</a>
			</div>
		</aside>
	</div>

</div>

{include file="frontend/components/footer.tpl"}
