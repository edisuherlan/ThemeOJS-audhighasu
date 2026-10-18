{**
 * Audhighasu — orange colophon footer
 * Author  : Edi Suherlan | audhighasu.com
*}

				</div><!-- pkp_structure_main -->

				{if empty($isFullWidth)}
					{capture assign="sidebarCode"}{call_hook name="Templates::Common::Sidebar"}{/capture}
					{if $sidebarCode}
						<aside class="pkp_structure_sidebar left ah-sidebar" role="complementary">{$sidebarCode}</aside>
					{/if}
				{/if}
			</div><!-- pkp_structure_content -->

			{if $currentContext && (!$requestedPage || $requestedPage === 'index')}
				<section class="ah-cta">
					<div class="ah-cta__pattern" aria-hidden="true"></div>
					<div class="ah-cta__inner">
						<p class="ah-cta__kicker">{translate key="plugins.themes.audhighasu.imprint.folio"}</p>
						<h2 class="ah-cta__title">{translate key="plugins.themes.audhighasu.cta.title"}</h2>
						<p class="ah-cta__text">{translate key="plugins.themes.audhighasu.cta.text"}</p>
						<a class="ah-btn ah-btn--ink" href="{url page="about" op="submissions"}">
							{translate key="plugins.themes.audhighasu.masthead.submit"}
						</a>
					</div>
				</section>
			{/if}

			<footer class="pkp_structure_footer_wrapper ah-footer" role="contentinfo">
				<a id="pkp_content_footer"></a>
				<div class="ah-footer__inner">
					<div class="ah-footer__grid">
						<div class="ah-footer__brand">
							<p class="ah-footer__eyebrow">{translate key="plugins.themes.audhighasu.imprint.folio"}</p>
							<h2 class="ah-footer__title">
								{if $currentContext}{$currentContext->getLocalizedName()|escape}{else}{translate key="common.software"}{/if}
							</h2>
							<p class="ah-footer__desc">
								{if $currentContext && $currentContext->getLocalizedData('description')}
									{$currentContext->getLocalizedData('description')|strip_tags|truncate:170}
								{/if}
							</p>
							{if $pageFooter}<div class="pkp_footer_content">{$pageFooter}</div>{/if}
						</div>
						<nav class="ah-footer__nav" aria-label="Footer">
							<h3 class="ah-footer__heading">{translate key="plugins.themes.audhighasu.footer.explore"}</h3>
							<ul>
								<li><a href="{url page="issue" op="current"}">{translate key="journal.currentIssue"}</a></li>
								<li><a href="{url page="issue" op="archive"}">{translate key="journal.viewAllIssues"}</a></li>
								<li><a href="{url page="search"}">{translate key="common.search"}</a></li>
								<li><a href="{url page="about"}">{translate key="about.aboutContext"}</a></li>
								<li><a href="{url page="about" op="contact"}">{translate key="about.contact"}</a></li>
							</ul>
						</nav>
					</div>
					<p class="ah-footer__copy">
						&copy; {$smarty.now|date_format:"Y"}
						{if $currentContext}{$currentContext->getLocalizedName()|escape}{/if}.
						{translate key="plugins.themes.audhighasu.footer.developedBy"}
						<a href="https://audhighasu.com" rel="noopener">audhighasu.com</a>
					</p>
				</div>
			</footer>
	</div><!-- ah-shell -->

{* PDF Flipbook Modal — Research Folio reader *}
<div id="ahPdfModal" class="ah-pdf-modal" hidden aria-hidden="true">
	<div class="ah-pdf-modal__backdrop" data-ah-pdf-close></div>
	<div class="ah-pdf-modal__dialog" role="dialog" aria-modal="true" aria-labelledby="ahPdfModalTitle">
		<header class="ah-pdf-modal__header">
			<div class="ah-pdf-modal__heading">
				<span class="ah-pdf-modal__badge" aria-hidden="true">
					<span class="ah-pdf-modal__badge-mark"></span>
					PDF
				</span>
				<h2 id="ahPdfModalTitle" class="ah-pdf-modal__title">{translate key="plugins.themes.audhighasu.pdf.reader"}</h2>
			</div>
			<div class="ah-pdf-modal__actions">
				<a class="ah-pdf-modal__btn ah-pdf-modal__btn--ghost" id="ahPdfDownload" href="#" target="_blank" rel="noopener" download>
					{translate key="common.download"}
				</a>
				<button type="button" class="ah-pdf-modal__btn ah-pdf-modal__btn--icon" data-ah-pdf-close aria-label="{translate|escape key="common.close"}">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
		</header>

		<div class="ah-pdf-modal__stage">
			<div class="ah-pdf-modal__loading" id="ahPdfLoading">
				<span class="ah-pdf-modal__spinner" aria-hidden="true"></span>
				<p>{translate key="plugins.themes.audhighasu.pdf.loading"}</p>
			</div>
			<div class="ah-pdf-modal__error" id="ahPdfError" hidden>
				<p>{translate key="plugins.themes.audhighasu.pdf.error"}</p>
				<a class="ah-pdf-modal__btn ah-pdf-modal__btn--solid" id="ahPdfErrorLink" href="#" target="_blank" rel="noopener">
					{translate key="common.download"}
				</a>
			</div>
			<div class="ah-pdf-modal__book-wrap">
				<div id="ahFlipbook" class="ah-pdf-modal__book"></div>
			</div>
		</div>

		<footer class="ah-pdf-modal__toolbar">
			<button type="button" class="ah-pdf-modal__btn ah-pdf-modal__btn--icon" id="ahPdfZoomOut" aria-label="Zoom out" title="Zoom out">
				<span aria-hidden="true">−</span>
			</button>
			<button type="button" class="ah-pdf-modal__btn ah-pdf-modal__btn--icon" id="ahPdfZoomIn" aria-label="Zoom in" title="Zoom in">
				<span aria-hidden="true">+</span>
			</button>
			<button type="button" class="ah-pdf-modal__btn" id="ahPdfViewMode" aria-label="Toggle 1 or 2 pages" title="1 / 2 pages">
				<span id="ahPdfViewModeLabel">1 hlm</span>
			</button>
			<button type="button" class="ah-pdf-modal__btn ah-pdf-modal__btn--icon" id="ahPdfPrev" aria-label="{translate|escape key="plugins.themes.audhighasu.pdf.prev"}">
				<span aria-hidden="true">‹</span>
			</button>
			<p class="ah-pdf-modal__pager" id="ahPdfPager">—</p>
			<button type="button" class="ah-pdf-modal__btn ah-pdf-modal__btn--icon" id="ahPdfNext" aria-label="{translate|escape key="plugins.themes.audhighasu.pdf.next"}">
				<span aria-hidden="true">›</span>
			</button>
		</footer>
	</div>
</div>

{load_script context="frontend"}
{call_hook name="Templates::Common::Footer::PageFooter"}
</body>
</html>
