{**
 * Audhighasu — language toggle
 * Author  : Edi Suherlan | audhighasu.com
*}
{if $ahEnableLanguageToggle}
	{assign var="langBtnId" value=$idPrefix|cat:"Btn"}
	{assign var="langMenuId" value=$idPrefix|cat:"Menu"}
	<div class="ah-lang" lang="{$currentLocale|replace:"_":"-"}">
		<button
			type="button"
			class="ah-lang__btn"
			aria-expanded="false"
			aria-haspopup="listbox"
			aria-controls="{$langMenuId|escape}"
			id="{$langBtnId|escape}"
		>
			<span class="ah-lang__label">
				{if isset($ahLanguageToggleLocales[$currentLocale])}
					{$ahLanguageToggleLocales[$currentLocale]|escape}
				{else}
					{$currentLocale|escape}
				{/if}
			</span>
			<span class="ah-lang__caret" aria-hidden="true"></span>
		</button>
		<ul class="ah-lang__menu" id="{$langMenuId|escape}" role="listbox" aria-labelledby="{$langBtnId|escape}" hidden>
			{foreach from=$ahLanguageToggleLocales item=localeName key=localeKey}
				<li class="ah-lang__item{if $localeKey === $currentLocale} is-current{/if}" role="option" {if $localeKey === $currentLocale}aria-selected="true"{else}aria-selected="false"{/if}>
					<a
						class="ah-lang__link{if $localeKey === $currentLocale} is-active{/if}"
						href="{url router=\PKP\core\PKPApplication::ROUTE_PAGE page="user" op="setLocale" path=$localeKey source=$smarty.server.REQUEST_URI}"
						{if $localeKey === $currentLocale}aria-current="true"{/if}
					>
						{$localeName|escape}
					</a>
				</li>
			{/foreach}
		</ul>
	</div>
{/if}
