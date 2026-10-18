{**
 * Audhighasu — lost password
 * Author  : Edi Suherlan | audhighasu.com
 *}
{assign var="isFullWidth" value=true}
{include file="frontend/components/header.tpl" pageTitle="user.login.resetPassword"}

<div class="page page_lost_password ah-auth ah-lost">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="user.login.resetPassword"}

	<div class="ah-auth__panel">
		<header class="ah-auth__intro">
			<p class="ah-kicker">{translate key="plugins.themes.audhighasu.lostPassword.kicker"}</p>
			<h1 class="ah-auth__title">{translate key="user.login.resetPassword"}</h1>
			<p class="ah-auth__lead">
				{translate key="plugins.themes.audhighasu.lostPassword.lead"}
			</p>
			<div class="ah-rule ah-rule--short" aria-hidden="true"><span></span></div>
		</header>

		<form class="cmp_form lost_password ah-auth__form" id="lostPasswordForm" action="{url page="login" op="requestResetPassword"}" method="post" role="form">
			{csrf}

			{if $error}
				<div class="pkp_form_error ah-auth__error" role="alert">
					{translate key=$error reason=$reason}
				</div>
			{/if}

			<fieldset class="fields ah-auth__fields">
				<legend class="pkp_screen_reader">{translate key="user.login.resetPassword"}</legend>

				<div class="email ah-auth__field">
					<label for="email">
						<span class="label">
							{translate key="user.login.registeredEmail"}
							<span class="required" aria-hidden="true">*</span>
							<span class="pkp_screen_reader">{translate key="common.required"}</span>
						</span>
					</label>
					<input
						type="email"
						name="email"
						id="email"
						value="{$email|escape}"
						required
						aria-required="true"
						autocomplete="email"
						placeholder="{translate|escape key="plugins.themes.audhighasu.lostPassword.emailPlaceholder"}"
					/>
				</div>

				{if $altchaEnabled}
					<fieldset class="altcha_wrapper">
						<div class="fields">
							<altcha-widget challengejson='{$altchaChallenge|@json_encode}' floating></altcha-widget>
						</div>
					</fieldset>
				{/if}

				<div class="buttons ah-auth__actions">
					<button class="submit ah-btn ah-btn--solid ah-auth__submit" type="submit">
						{translate key="user.login.resetPassword"}
					</button>
					<a href="{url page="login"}" class="ah-btn ah-btn--ghost ah-auth__alt">
						{translate key="user.login"}
					</a>
					{if !$disableUserReg}
						{capture assign=registerUrl}{url page="user" op="register" source=$source}{/capture}
						<a href="{$registerUrl}" class="ah-btn ah-btn--ghost ah-auth__alt">
							{translate key="user.login.registerNewAccount"}
						</a>
					{/if}
				</div>
			</fieldset>
		</form>
	</div>
</div>

{include file="frontend/components/footer.tpl"}
