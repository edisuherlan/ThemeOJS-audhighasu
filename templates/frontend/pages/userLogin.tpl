{**
 * Audhighasu — login (author desk)
 * Author  : Edi Suherlan | audhighasu.com
 *}
{assign var="isFullWidth" value=true}
{include file="frontend/components/header.tpl" pageTitle="user.login"}

<div class="page page_login ah-auth">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="user.login"}

	<div class="ah-auth__panel">
		<header class="ah-auth__intro">
			<p class="ah-kicker">{translate key="plugins.themes.audhighasu.login.kicker"}</p>
			<h1 class="ah-auth__title">{translate key="user.login"}</h1>
			<p class="ah-auth__lead">
				{if $loginMessage}
					{translate key=$loginMessage}
				{else}
					{translate key="plugins.themes.audhighasu.login.lead"}
				{/if}
			</p>
			<div class="ah-rule ah-rule--short" aria-hidden="true"><span></span></div>
		</header>

		{if !$disableUserReg}
			{capture assign=registerUrl}{url page="user" op="register" source=$source}{/capture}
		{/if}

		<form class="cmp_form login ah-auth__form" id="login" method="post" action="{$loginUrl}" role="form">
			{csrf}

			{if $error}
				<div class="pkp_form_error ah-auth__error" role="alert">
					{translate key=$error reason=$reason}
				</div>
			{/if}

			<input type="hidden" name="source" value="{$source|default:""|escape}" />

			<fieldset class="fields ah-auth__fields">
				<legend class="pkp_screen_reader">{translate key="user.login"}</legend>

				<div class="ah-auth__grid">
					<div class="username ah-auth__field">
						<label for="username">
							<span class="label">
								{translate key="user.usernameOrEmail"}
								<span class="required" aria-hidden="true">*</span>
								<span class="pkp_screen_reader">{translate key="common.required"}</span>
							</span>
						</label>
						<input
							type="text"
							name="username"
							id="username"
							value="{$username|default:""|escape}"
							required
							aria-required="true"
							autocomplete="username"
							placeholder="{translate|escape key="plugins.themes.audhighasu.login.usernamePlaceholder"}"
						/>
					</div>

					<div class="password ah-auth__field">
						<div class="ah-auth__label-row">
							<label for="password">
								<span class="label">
									{translate key="user.password"}
									<span class="required" aria-hidden="true">*</span>
									<span class="pkp_screen_reader">{translate key="common.required"}</span>
								</span>
							</label>
							<a class="ah-auth__forgot" href="{url page="login" op="lostPassword"}">
								{translate key="user.login.forgotPassword"}
							</a>
						</div>
						<div class="ah-auth__passwrap">
							<input
								type="password"
								name="password"
								id="password"
								value="{$password|default:""|escape}"
								password="true"
								maxlength="32"
								required
								aria-required="true"
								autocomplete="current-password"
								placeholder="{translate|escape key="plugins.themes.audhighasu.login.passwordPlaceholder"}"
							/>
							<button
								type="button"
								class="ah-auth__peek"
								data-ah-password-peek
								aria-controls="password"
								aria-pressed="false"
								aria-label="{translate|escape key="plugins.themes.audhighasu.login.showPassword"}"
								data-label-show="{translate|escape key="plugins.themes.audhighasu.login.showPassword"}"
								data-label-hide="{translate|escape key="plugins.themes.audhighasu.login.hidePassword"}"
							>
								<span class="ah-auth__peek-icon ah-auth__peek-icon--show" aria-hidden="true">
									<svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7S1 12 1 12z"/><circle cx="12" cy="12" r="3"/></svg>
								</span>
								<span class="ah-auth__peek-icon ah-auth__peek-icon--hide" aria-hidden="true" hidden>
									<svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94"/><path d="M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19"/><path d="M14.12 14.12a3 3 0 1 1-4.24-4.24"/><line x1="1" y1="1" x2="23" y2="23"/></svg>
								</span>
							</button>
						</div>
					</div>
				</div>

				<div class="remember checkbox ah-auth__remember">
					<label>
						<input type="checkbox" name="remember" id="remember" value="1" checked="$remember">
						<span class="label">
							{translate key="user.login.rememberUsernameAndPassword"}
						</span>
					</label>
				</div>

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
						{translate key="user.login"}
					</button>
					{if !$disableUserReg}
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
