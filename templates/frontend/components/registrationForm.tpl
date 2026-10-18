{**
 * Audhighasu — registration fields
 * Author  : Edi Suherlan | audhighasu.com
 *}
<fieldset class="identity ah-register__section">
	<legend>{translate key="user.profile"}</legend>
	<div class="fields ah-register__grid">
		<div class="given_name ah-auth__field">
			<label for="givenName">
				<span class="label">
					{translate key="user.givenName"}
					<span class="required" aria-hidden="true">*</span>
					<span class="pkp_screen_reader">{translate key="common.required"}</span>
				</span>
			</label>
			<input type="text" name="givenName" autocomplete="given-name" id="givenName" value="{$givenName|default:""|escape}" maxlength="255" required aria-required="true">
		</div>
		<div class="family_name ah-auth__field">
			<label for="familyName">
				<span class="label">{translate key="user.familyName"}</span>
			</label>
			<input type="text" name="familyName" autocomplete="family-name" id="familyName" value="{$familyName|default:""|escape}" maxlength="255">
		</div>
		<div class="affiliation ah-auth__field">
			<label for="affiliation">
				<span class="label">
					{translate key="user.affiliation"}
					<span class="required" aria-hidden="true">*</span>
					<span class="pkp_screen_reader">{translate key="common.required"}</span>
				</span>
			</label>
			<input type="text" name="affiliation" autocomplete="organization" id="affiliation" value="{$affiliation|default:""|escape}" required aria-required="true">
		</div>
		<div class="country ah-auth__field">
			<label for="country">
				<span class="label">
					{translate key="common.country"}
					<span class="required" aria-hidden="true">*</span>
					<span class="pkp_screen_reader">{translate key="common.required"}</span>
				</span>
			</label>
			<select name="country" id="country" autocomplete="country-name" required aria-required="true">
				<option></option>
				{html_options options=$countries selected=$country}
			</select>
		</div>
	</div>
</fieldset>

<fieldset class="login ah-register__section">
	<legend>{translate key="user.login"}</legend>
	<div class="fields ah-register__grid">
		<div class="email ah-auth__field">
			<label for="email">
				<span class="label">
					{translate key="user.email"}
					<span class="required" aria-hidden="true">*</span>
					<span class="pkp_screen_reader">{translate key="common.required"}</span>
				</span>
			</label>
			<input type="email" name="email" id="email" value="{$email|default:""|escape}" maxlength="90" required aria-required="true" autocomplete="email">
		</div>
		<div class="username ah-auth__field">
			<label for="username">
				<span class="label">
					{translate key="user.username"}
					<span class="required" aria-hidden="true">*</span>
					<span class="pkp_screen_reader">{translate key="common.required"}</span>
				</span>
			</label>
			<input type="text" name="username" id="username" value="{$username|default:""|escape}" maxlength="32" required aria-required="true" autocomplete="username">
		</div>
		<div class="password ah-auth__field">
			<label for="password">
				<span class="label">
					{translate key="user.password"}
					<span class="required" aria-hidden="true">*</span>
					<span class="pkp_screen_reader">{translate key="common.required"}</span>
				</span>
			</label>
			<div class="ah-auth__passwrap">
				<input type="password" name="password" id="password" password="true" maxlength="32" required aria-required="true" autocomplete="new-password">
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
		<div class="password ah-auth__field">
			<label for="password2">
				<span class="label">
					{translate key="user.repeatPassword"}
					<span class="required" aria-hidden="true">*</span>
					<span class="pkp_screen_reader">{translate key="common.required"}</span>
				</span>
			</label>
			<div class="ah-auth__passwrap">
				<input type="password" name="password2" id="password2" password="true" maxlength="32" required aria-required="true" autocomplete="new-password">
				<button
					type="button"
					class="ah-auth__peek"
					data-ah-password-peek
					aria-controls="password2"
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
</fieldset>
