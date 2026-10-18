{**
 * Audhighasu — registration
 * Author  : Edi Suherlan | audhighasu.com
 *}
{assign var="isFullWidth" value=true}
{include file="frontend/components/header.tpl" pageTitle="user.register"}

{assign var="siteContextId" value=PKP\core\PKPApplication::SITE_CONTEXT_ID|intval}

<div class="page page_register ah-auth ah-register">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="user.register"}

	<div class="ah-auth__panel">
		<header class="ah-auth__intro">
			<p class="ah-kicker">{translate key="plugins.themes.audhighasu.register.kicker"}</p>
			<h1 class="ah-auth__title">{translate key="user.register"}</h1>
			<p class="ah-auth__lead">
				{translate key="plugins.themes.audhighasu.register.lead"}
			</p>
			<p class="ah-register__hint">{translate key="common.requiredField"}</p>
			<div class="ah-rule ah-rule--short" aria-hidden="true"><span></span></div>
		</header>

		<form class="cmp_form register ah-auth__form ah-register__form" id="register" method="post" action="{url op="register"}" role="form">
			{if $orcidEnabled}
				{include file="form/orcidProfile.tpl"}
			{/if}

			{csrf}

			{if $source}
				<input type="hidden" name="source" value="{$source|escape}" />
			{/if}

			{include file="common/formErrors.tpl"}

			{include file="frontend/components/registrationForm.tpl"}

			{if $currentContext}
				<fieldset class="consent ah-register__consent">
					{if $currentContext->getData('privacyStatement')}
						<legend class="pkp_screen_reader">{translate key="user.register.form.privacyConsentLabel"}</legend>
						<div class="fields">
							<div class="optin optin-privacy">
								<label>
									<input type="checkbox" name="privacyConsent" value="1"{if $privacyConsent} checked="checked"{/if}>
									{capture assign="privacyUrl"}{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="privacy"}{/capture}
									{translate key="user.register.form.privacyConsent" privacyUrl=$privacyUrl}
								</label>
							</div>
						</div>
					{/if}
					<div class="fields">
						<div class="optin optin-email">
							<label>
								<input type="checkbox" name="emailConsent" value="1"{if $emailConsent} checked="checked"{/if}>
								{translate key="user.register.form.emailConsent"}
							</label>
						</div>
					</div>
				</fieldset>

				{assign var=contextId value=$currentContext->getId()}
				{assign var=userCanRegisterReviewer value=0}
				{foreach from=$reviewerUserGroups[$contextId] item=userGroup}
					{if $userGroup->permitSelfRegistration}
						{assign var=userCanRegisterReviewer value=$userCanRegisterReviewer+1}
					{/if}
				{/foreach}
				{if $userCanRegisterReviewer}
					<fieldset class="reviewer ah-register__reviewer">
						{if $userCanRegisterReviewer > 1}
							<legend>{translate key="user.reviewerPrompt"}</legend>
							{capture assign="checkboxLocaleKey"}user.reviewerPrompt.userGroup{/capture}
						{else}
							{capture assign="checkboxLocaleKey"}user.reviewerPrompt.optin{/capture}
						{/if}
						<div class="fields">
							<div id="reviewerOptinGroup" class="optin">
								{foreach from=$reviewerUserGroups[$contextId] item=userGroup}
									{if $userGroup->permitSelfRegistration}
										<label>
											{assign var="userGroupId" value=$userGroup->id}
											<input type="checkbox" name="reviewerGroup[{$userGroupId}]" value="1"{if in_array($userGroupId, $userGroupIds)} checked="checked"{/if}>
											{translate key=$checkboxLocaleKey userGroup=$userGroup->getLocalizedData('name')}
										</label>
									{/if}
								{/foreach}
							</div>
							<div id="reviewerInterests" class="reviewer_interests">
								<label>
									<span class="label">{translate key="user.interests"}</span>
									<input type="text" name="interests" id="interests" value="{$interests|default:""|escape}">
								</label>
							</div>
						</div>
					</fieldset>
				{/if}
			{/if}

			{include file="frontend/components/registrationFormContexts.tpl"}

			{if !$currentContext}
				<div class="fields">
					<div class="reviewer_nocontext_interests">
						<label>
							<span class="label">{translate key="user.register.noContextReviewerInterests"}</span>
							<input type="text" name="interests" id="interests" value="{$interests|default:""|escape}">
						</label>
					</div>
				</div>

				{if $siteWidePrivacyStatement}
					<div class="fields">
						<div class="optin optin-privacy">
							<label>
								<input type="checkbox" name="privacyConsent[{$siteContextId}]" id="privacyConsent[{$siteContextId}]" value="1"{if $privacyConsent[$siteContextId]} checked="checked"{/if}>
								{capture assign="privacyUrl"}{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="privacy"}{/capture}
								{translate key="user.register.form.privacyConsent" privacyUrl=$privacyUrl}
							</label>
						</div>
					</div>
				{/if}

				<div class="fields">
					<div class="optin optin-email">
						<label>
							<input type="checkbox" name="emailConsent" value="1"{if $emailConsent} checked="checked"{/if}>
							{translate key="user.register.form.emailConsent"}
						</label>
					</div>
				</div>
			{/if}

			{if $recaptchaPublicKey}
				<fieldset class="recaptcha_wrapper">
					<div class="fields">
						<div class="recaptcha">
							<div class="g-recaptcha" data-sitekey="{$recaptchaPublicKey|escape}"></div>
							<label for="g-recaptcha-response" style="display:none;" hidden>Recaptcha response</label>
						</div>
					</div>
				</fieldset>
			{/if}

			{if $altchaEnabled}
				<fieldset class="altcha_wrapper">
					<div class="fields">
						<altcha-widget challengejson='{$altchaChallenge|@json_encode}' floating></altcha-widget>
					</div>
				</fieldset>
			{/if}

			<div class="buttons ah-auth__actions">
				<button class="submit ah-btn ah-btn--solid ah-auth__submit" type="submit">
					{translate key="user.register"}
				</button>
				{capture assign="rolesProfileUrl"}{url page="user" op="profile" path="roles"}{/capture}
				<a href="{url page="login" source=$rolesProfileUrl}" class="ah-btn ah-btn--ghost ah-auth__alt">
					{translate key="user.login"}
				</a>
			</div>
		</form>
	</div>
</div>

{include file="frontend/components/footer.tpl"}
