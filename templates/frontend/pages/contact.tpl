{**
 * Audhighasu — contact
 * Author  : Edi Suherlan | audhighasu.com
 *}
{assign var="isFullWidth" value=true}
{include file="frontend/components/header.tpl" pageTitle="about.contact"}

<div class="page page_contact ah-page">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="about.contact"}
	{include file="frontend/components/pageIntro.tpl" ahKickerKey="plugins.themes.audhighasu.contact.kicker" ahTitleKey="about.contact" ahLeadKey="plugins.themes.audhighasu.contact.lead"}
	{include file="frontend/components/editLink.tpl" page="management" op="settings" path="context" anchor="contact" sectionTitleKey="about.contact"}

	<div class="ah-contact">
		{if $mailingAddress}
			<section class="ah-panel ah-contact__block">
				<h2 class="ah-panel__title">{translate key="common.mailingAddress"}</h2>
				<p class="ah-contact__address">{$mailingAddress|nl2br|strip_unsafe_html}</p>
			</section>
		{/if}

		{if $contactTitle || $contactName || $contactAffiliation || $contactPhone || $contactEmail}
			<section class="ah-panel ah-contact__block">
				<h2 class="ah-panel__title">{translate key="about.contact.principalContact"}</h2>
				{if $contactName}<p class="ah-contact__name">{$contactName|escape}</p>{/if}
				{if $contactTitle}<p class="ah-contact__meta">{$contactTitle|escape}</p>{/if}
				{if $contactAffiliation}<p class="ah-contact__meta">{$contactAffiliation|strip_unsafe_html}</p>{/if}
				<ul class="ah-contact__list">
					{if $contactPhone}
						<li><span>{translate key="about.contact.phone"}</span> {$contactPhone|escape}</li>
					{/if}
					{if $contactEmail}
						<li><span>{translate key="about.contact.email"}</span> {mailto address=$contactEmail encode="javascript"}</li>
					{/if}
				</ul>
			</section>
		{/if}

		{if $supportName || $supportPhone || $supportEmail}
			<section class="ah-panel ah-contact__block">
				<h2 class="ah-panel__title">{translate key="about.contact.supportContact"}</h2>
				{if $supportName}<p class="ah-contact__name">{$supportName|escape}</p>{/if}
				<ul class="ah-contact__list">
					{if $supportPhone}
						<li><span>{translate key="about.contact.phone"}</span> {$supportPhone|escape}</li>
					{/if}
					{if $supportEmail}
						<li><span>{translate key="about.contact.email"}</span> {mailto address=$supportEmail encode="javascript"}</li>
					{/if}
				</ul>
			</section>
		{/if}
	</div>
</div>

{include file="frontend/components/footer.tpl"}
