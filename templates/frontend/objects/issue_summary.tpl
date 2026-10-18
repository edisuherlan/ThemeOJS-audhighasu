{**
 * Audhighasu — issue summary for archive
 * Author  : Edi Suherlan | audhighasu.com
 *}
{if $issue->getShowTitle()}
	{assign var=issueTitle value=$issue->getLocalizedTitle()}
{/if}
{assign var=issueSeries value=$issue->getIssueSeries()}
{assign var=issueCover value=$issue->getLocalizedCoverImageUrl()}

<article class="obj_issue_summary ah-issue-card">
	{if $issueCover}
		<a class="cover ah-issue-card__cover" href="{url op="view" path=$issue->getBestIssueId()}">
			<img src="{$issueCover|escape}" alt="{$issue->getLocalizedCoverImageAltText()|escape|default:''}" loading="lazy" />
		</a>
	{else}
		<a class="cover ah-issue-card__cover ah-issue-card__cover--placeholder" href="{url op="view" path=$issue->getBestIssueId()}" aria-hidden="true">
			<span>{$issue->getYear()|escape}</span>
			<em>Vol. {$issue->getVolume()|escape}</em>
		</a>
	{/if}

	<div class="ah-issue-card__body">
		<p class="ah-issue-card__meta">
			<span>Vol {$issue->getVolume()|escape}</span>
			<span>No {$issue->getNumber()|escape}</span>
			<span>{$issue->getYear()|escape}</span>
		</p>
		{if $issueSeries}
			<p class="series ah-issue-card__series">{$issueSeries|escape}</p>
		{/if}
		<h2 class="ah-issue-card__title">
			<a class="title" href="{url op="view" path=$issue->getBestIssueId()}">
				{if $issueTitle}{$issueTitle|escape}{else}{$issueSeries|escape}{/if}
			</a>
		</h2>
		{if $issue->getLocalizedDescription()}
			<div class="description ah-issue-card__desc">
				{$issue->getLocalizedDescription()|strip_tags|truncate:160}
			</div>
		{/if}
		{if $issue->getDatePublished()}
			<p class="ah-issue-card__published">
				{translate key="submissions.published"}
				<strong>{$issue->getDatePublished()|date_format:$dateFormatShort}</strong>
			</p>
		{/if}
	</div>
</article>
