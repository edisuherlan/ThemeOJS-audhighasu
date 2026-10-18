{**
 * Audhighasu — editorial masthead
 * Author  : Edi Suherlan | audhighasu.com
 *}
{assign var="isFullWidth" value=true}
{include file="frontend/components/header.tpl" pageTitle="common.editorialMasthead"}

<div class="page page_masthead ah-page">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="common.editorialMasthead"}
	{include file="frontend/components/pageIntro.tpl" ahKickerKey="plugins.themes.audhighasu.mastheadPage.kicker" ahTitleKey="common.editorialMasthead" ahLeadKey="plugins.themes.audhighasu.mastheadPage.lead"}

	{foreach from=$mastheadRoles item=mastheadRole}
		{assign var="roleId" value=$mastheadRole->id}
		{if isset($mastheadUsers[$roleId])}
			<section class="ah-panel ah-mast-role">
				<h2 class="ah-panel__title">{$mastheadRole->getLocalizedData('name')|escape}</h2>
				<ul class="ah-mast-list">
					{foreach from=$mastheadUsers[$roleId] item=user}
						<li>
							<strong>{$user.userName|escape}</strong>
							{if $user.userAffiliation}
								<span>{$user.userAffiliation|escape}</span>
							{/if}
						</li>
					{/foreach}
				</ul>
			</section>
		{/if}
	{/foreach}

	{if !empty($reviewers)}
		<section class="ah-panel ah-mast-role">
			<h2 class="ah-panel__title">{translate key="user.role.reviewers"}</h2>
			<ul class="ah-mast-list">
				{foreach from=$reviewers item=reviewer}
					<li>
						<strong>{$reviewer.userName|escape}</strong>
						{if $reviewer.userAffiliation}
							<span>{$reviewer.userAffiliation|escape}</span>
						{/if}
					</li>
				{/foreach}
			</ul>
		</section>
	{/if}
</div>

{include file="frontend/components/footer.tpl"}
