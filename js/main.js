/*!
 * Audhighasu — research folio frontend
 * Author  : Edi Suherlan | audhighasu.com
 */
(function () {
	'use strict';

	function closest(el, selector) {
		while (el && el.nodeType === 1) {
			if (el.matches(selector)) return el;
			el = el.parentElement;
		}
		return null;
	}

	function isMobileNav() {
		return window.matchMedia('(max-width: 960px)').matches;
	}

	/**
	 * Disable Default Theme Bootstrap dropdowns on primary nav —
	 * they rewrite href to "#" and fight our absolute positioning via transform.
	 */
	function neutralizeBootstrapDropdowns(nav) {
		if (!nav) return;

		if (window.jQuery && window.jQuery.fn && typeof window.jQuery.fn.dropdown === 'function') {
			try {
				window.jQuery(nav).find('[data-toggle="dropdown"]').dropdown('dispose');
			} catch (e) { /* ignore */ }
		}

		nav.querySelectorAll('ul').forEach(function (ul) {
			ul.classList.remove('dropdown-menu', 'show');
			ul.removeAttribute('aria-labelledby');
			ul.removeAttribute('style');
		});

		nav.querySelectorAll(':scope > li').forEach(function (li) {
			li.classList.remove('show', 'dropdown');
			var a = li.querySelector(':scope > a');
			if (!a) return;
			a.removeAttribute('data-toggle');
			a.removeAttribute('aria-haspopup');
			a.removeAttribute('aria-expanded');
			a.classList.remove('dropdown-toggle');
		});
	}

	/**
	 * Primary nav submenus (Tentang Kami, etc.)
	 * Desktop: CSS hover/focus-within
	 * Mobile: click accordion (.is-open)
	 */
	function bindPrimarySubmenus(nav) {
		if (!nav || nav.getAttribute('data-ah-subnav') === '1') return;

		neutralizeBootstrapDropdowns(nav);

		nav.querySelectorAll(':scope > li').forEach(function (li) {
			var link = li.querySelector(':scope > a');
			var sub = li.querySelector(':scope > ul');
			if (!link || !sub) return;

			li.classList.add('ah-nav__has-sub');

			if (!link.querySelector('.ah-nav__chevron')) {
				var chevron = document.createElement('span');
				chevron.className = 'ah-nav__chevron';
				chevron.setAttribute('aria-hidden', 'true');
				link.appendChild(chevron);
			}

			if (!sub.id) {
				sub.id = 'ahSub-' + Math.random().toString(36).slice(2, 9);
			}

			// Parent is a submenu toggle, not a destination
			link.setAttribute('href', '#');
			link.setAttribute('role', 'button');
			link.setAttribute('aria-haspopup', 'true');
			link.setAttribute('aria-controls', sub.id);
			link.setAttribute('aria-expanded', li.classList.contains('is-open') ? 'true' : 'false');

			if (link.getAttribute('data-ah-sub-bound') === '1') return;
			link.setAttribute('data-ah-sub-bound', '1');

			link.addEventListener('click', function (e) {
				e.preventDefault();
				e.stopPropagation();

				var willOpen = !li.classList.contains('is-open');
				nav.querySelectorAll(':scope > li.is-open').forEach(function (openLi) {
					if (openLi === li) return;
					openLi.classList.remove('is-open');
					var openLink = openLi.querySelector(':scope > a');
					if (openLink) openLink.setAttribute('aria-expanded', 'false');
				});
				li.classList.toggle('is-open', willOpen);
				link.setAttribute('aria-expanded', willOpen ? 'true' : 'false');
			});
		});

		nav.setAttribute('data-ah-subnav', '1');
	}

	function initPrimarySubmenus() {
		bindPrimarySubmenus(document.getElementById('navigationPrimary'));
		bindPrimarySubmenus(document.getElementById('navigationPrimaryMobile'));
	}

	function initMobileNav() {
		var toggle = document.querySelector('[data-ah-nav-toggle]');
		var panel = document.getElementById('ahNavPanel');
		var backdrop = document.querySelector('[data-ah-nav-backdrop]');
		var closeBtn = document.querySelector('[data-ah-nav-close]');
		if (!toggle || !panel) return;

		function setOpen(open) {
			document.body.classList.toggle('ah-nav-open', open);
			document.documentElement.classList.toggle('ah-nav-open', open);
			toggle.setAttribute('aria-expanded', open ? 'true' : 'false');
			panel.setAttribute('aria-hidden', open ? 'false' : 'true');
			if (open) {
				panel.removeAttribute('hidden');
			} else {
				panel.setAttribute('hidden', 'hidden');
			}
			if (backdrop) {
				if (open) backdrop.removeAttribute('hidden');
				else backdrop.setAttribute('hidden', 'hidden');
			}
			if (!open) {
				panel.querySelectorAll('.ah-nav__list > li.is-open').forEach(function (li) {
					li.classList.remove('is-open');
					var link = li.querySelector(':scope > a');
					if (link) link.setAttribute('aria-expanded', 'false');
				});
			} else if (closeBtn) {
				window.setTimeout(function () { closeBtn.focus(); }, 40);
			}
		}

		panel.setAttribute('aria-hidden', 'true');
		panel.setAttribute('hidden', 'hidden');

		toggle.addEventListener('click', function (e) {
			e.preventDefault();
			e.stopPropagation();
			setOpen(!document.body.classList.contains('ah-nav-open'));
		});
		if (closeBtn) {
			closeBtn.addEventListener('click', function (e) {
				e.preventDefault();
				setOpen(false);
				toggle.focus();
			});
		}
		if (backdrop) {
			backdrop.addEventListener('click', function () { setOpen(false); });
		}
		document.addEventListener('keydown', function (e) {
			if (e.key === 'Escape') setOpen(false);
		});
		document.addEventListener('click', function (e) {
			if (closest(e.target, '#navigationPrimary')) return;
			var nav = document.getElementById('navigationPrimary');
			if (!nav || isMobileNav()) return;
			nav.querySelectorAll(':scope > li.is-open').forEach(function (li) {
				li.classList.remove('is-open');
				var link = li.querySelector(':scope > a');
				if (link) link.setAttribute('aria-expanded', 'false');
			});
		});
		panel.querySelectorAll('a').forEach(function (a) {
			a.addEventListener('click', function () {
				if (!isMobileNav()) return;
				var li = a.parentElement;
				if (li && li.classList.contains('ah-nav__has-sub') && a === li.querySelector(':scope > a')) {
					return;
				}
				setOpen(false);
			});
		});
		window.addEventListener('resize', function () {
			if (!isMobileNav() && document.body.classList.contains('ah-nav-open')) {
				setOpen(false);
			}
		});
	}

	function closeAllLangMenus() {
		document.querySelectorAll('.ah-lang').forEach(function (wrap) {
			var btn = wrap.querySelector('.ah-lang__btn');
			var menu = wrap.querySelector('.ah-lang__menu');
			wrap.classList.remove('is-open');
			if (btn) btn.setAttribute('aria-expanded', 'false');
			if (menu) menu.setAttribute('hidden', 'hidden');
		});
	}

	function initLanguageToggles() {
		document.querySelectorAll('.ah-lang').forEach(function (wrap) {
			var btn = wrap.querySelector('.ah-lang__btn');
			var menu = wrap.querySelector('.ah-lang__menu');
			if (!btn || !menu) return;

			btn.addEventListener('click', function (e) {
				e.preventDefault();
				e.stopPropagation();
				var willOpen = menu.hasAttribute('hidden');
				closeAllLangMenus();
				if (willOpen) {
					wrap.classList.add('is-open');
					menu.removeAttribute('hidden');
					btn.setAttribute('aria-expanded', 'true');
				}
			});
		});

		document.addEventListener('click', function (e) {
			if (closest(e.target, '.ah-lang')) return;
			closeAllLangMenus();
		});

		document.addEventListener('keydown', function (e) {
			if (e.key === 'Escape') closeAllLangMenus();
		});
	}

	function initPasswordPeek() {
		document.querySelectorAll('[data-ah-password-peek]').forEach(function (btn) {
			if (btn.getAttribute('data-ah-peek-ready') === '1') return;
			btn.setAttribute('data-ah-peek-ready', '1');

			btn.addEventListener('click', function () {
				var targetId = btn.getAttribute('aria-controls');
				var input = targetId ? document.getElementById(targetId) : null;
				if (!input) {
					var wrap = closest(btn, '.ah-auth__passwrap');
					input = wrap ? wrap.querySelector('input') : null;
				}
				if (!input) return;

				var show = input.type === 'password';
				input.type = show ? 'text' : 'password';
				btn.setAttribute('aria-pressed', show ? 'true' : 'false');
				btn.setAttribute(
					'aria-label',
					show
						? (btn.getAttribute('data-label-hide') || 'Hide password')
						: (btn.getAttribute('data-label-show') || 'Show password')
				);

				var iconShow = btn.querySelector('.ah-auth__peek-icon--show');
				var iconHide = btn.querySelector('.ah-auth__peek-icon--hide');
				if (iconShow) iconShow.hidden = show;
				if (iconHide) iconHide.hidden = !show;
			});
		});
	}

	/**
	 * Theme Chart.js colours for article usage stats (orange folio).
	 * Must run before usage-stats-chart.js initializes — listen early.
	 */
	document.addEventListener('usageStatsChartOptions.pkp', function (e) {
		if (!e.chartOptions) return;
		var fill = 'rgba(232, 93, 4, 0.72)';
		var fillSoft = 'rgba(232, 93, 4, 0.22)';
		var border = 'rgba(232, 93, 4, 0.95)';
		if (!e.chartOptions.elements) e.chartOptions.elements = {};
		if (!e.chartOptions.elements.bar) e.chartOptions.elements.bar = {};
		if (!e.chartOptions.elements.line) e.chartOptions.elements.line = {};
		if (!e.chartOptions.elements.point) e.chartOptions.elements.point = {};
		e.chartOptions.elements.bar.backgroundColor = fill;
		e.chartOptions.elements.bar.borderRadius = 3;
		e.chartOptions.elements.bar.borderSkipped = false;
		e.chartOptions.elements.line.backgroundColor = fillSoft;
		e.chartOptions.elements.line.borderColor = border;
		e.chartOptions.elements.line.borderWidth = 2.5;
		e.chartOptions.elements.point.backgroundColor = '#fff';
		e.chartOptions.elements.point.borderColor = border;
		if (e.chartOptions.tooltip) {
			e.chartOptions.tooltip.backgroundColor = '#1C1917';
			e.chartOptions.tooltip.titleFontColor = '#fff';
			e.chartOptions.tooltip.bodyFontColor = '#FFF7ED';
			e.chartOptions.tooltip.footerFontColor = '#FFF7ED';
			e.chartOptions.tooltip.cornerRadius = 4;
		}
		if (e.chartOptions.scales && e.chartOptions.scales.x && e.chartOptions.scales.x.grid) {
			e.chartOptions.scales.x.ticks = e.chartOptions.scales.x.ticks || {};
			e.chartOptions.scales.x.ticks.color = '#78716C';
			e.chartOptions.scales.x.ticks.font = { size: 11, weight: '600' };
		}
		if (e.chartOptions.scales && e.chartOptions.scales.y && e.chartOptions.scales.y.grid) {
			e.chartOptions.scales.y.grid.color = 'rgba(232, 93, 4, 0.08)';
			e.chartOptions.scales.y.ticks = e.chartOptions.scales.y.ticks || {};
			e.chartOptions.scales.y.ticks.color = '#78716C';
			e.chartOptions.scales.y.ticks.font = { size: 11 };
		}
	});

	document.addEventListener('usageStatsChartLoaded.pkp', function (e) {
		var canvas = e.target;
		if (!canvas || !canvas.closest) return;
		var section = canvas.closest('.ah-stats-chart');
		var objectType = canvas.dataset.objectType;
		var objectId = canvas.dataset.objectId;

		// Force orange palette on the live Chart.js instance (covers late script order)
		try {
			var key = objectType + '_' + objectId;
			var chart = window.pkpUsageStats && window.pkpUsageStats.charts && window.pkpUsageStats.charts[key];
			if (chart) {
				var fill = 'rgba(232, 93, 4, 0.72)';
				var fillSoft = 'rgba(232, 93, 4, 0.22)';
				var border = 'rgba(232, 93, 4, 0.95)';
				if (chart.options && chart.options.elements) {
					if (chart.options.elements.bar) {
						chart.options.elements.bar.backgroundColor = fill;
						chart.options.elements.bar.borderRadius = 3;
					}
					if (chart.options.elements.line) {
						chart.options.elements.line.backgroundColor = fillSoft;
						chart.options.elements.line.borderColor = border;
					}
					if (chart.options.elements.point) {
						chart.options.elements.point.backgroundColor = '#fff';
						chart.options.elements.point.borderColor = border;
					}
				}
				if (chart.data && chart.data.datasets && chart.data.datasets[0]) {
					var ds = chart.data.datasets[0];
					if (chart.config && chart.config.type === 'line') {
						ds.backgroundColor = fillSoft;
						ds.borderColor = border;
					} else {
						ds.backgroundColor = fill;
						ds.borderColor = border;
						ds.borderWidth = 0;
						ds.borderRadius = 3;
					}
				}
				chart.update('none');
			}
		} catch (err) { /* ignore */ }

		if (!section || section.querySelector('.ah-stats-chart__total')) return;
		var total = 0;
		try {
			if (window.pkpUsageStats && window.pkpUsageStats.data
				&& window.pkpUsageStats.data[objectType]
				&& window.pkpUsageStats.data[objectType][objectId]) {
				total = Number(window.pkpUsageStats.data[objectType][objectId].total) || 0;
			}
		} catch (err2) { /* ignore */ }
		var badge = document.createElement('div');
		badge.className = 'ah-stats-chart__total';
		badge.innerHTML = '<span class="ah-stats-chart__total-num">' + total.toLocaleString() + '</span>'
			+ '<span class="ah-stats-chart__total-label">Total</span>';
		var head = section.querySelector('.ah-stats-chart__head');
		if (head) head.appendChild(badge);
		else section.insertBefore(badge, section.firstChild);
	});

	/**
	 * PDF flipbook — PDF.js + StPageFlip (Research Folio modal)
	 */
	function initPdfFlipbook() {
		var modal = document.getElementById('ahPdfModal');
		if (!modal) return;
		if (modal.getAttribute('data-ah-pdf-ready') === '1') return;
		if (typeof pdfjsLib === 'undefined' || typeof St === 'undefined' || !St.PageFlip) return;

		modal.setAttribute('data-ah-pdf-ready', '1');
		document.body.appendChild(modal);

		pdfjsLib.GlobalWorkerOptions.workerSrc =
			'https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.worker.min.js';

		var pageFlip = null;
		var objectUrls = [];
		var lastImages = null;
		var viewMode = 'single'; // single = readable; spread = 2-page magazine
		var zoomLevel = 1;
		var savedPage = 0;
		var loading = document.getElementById('ahPdfLoading');
		var errorEl = document.getElementById('ahPdfError');
		var titleEl = document.getElementById('ahPdfModalTitle');
		var pager = document.getElementById('ahPdfPager');
		var download = document.getElementById('ahPdfDownload');
		var errorLink = document.getElementById('ahPdfErrorLink');
		var viewModeLabel = document.getElementById('ahPdfViewModeLabel');
		var lastFocus = null;
		var loadToken = 0;

		function toDownloadUrl(viewUrl) {
			return String(viewUrl || '').replace(
				/\/(article|issue)\/view\//,
				'/$1/download/'
			);
		}

		function revokeUrls() {
			objectUrls.forEach(function (url) {
				try { URL.revokeObjectURL(url); } catch (e) { /* ignore */ }
			});
			objectUrls = [];
		}

		function getBookWrap() {
			var wrap = modal.querySelector('.ah-pdf-modal__book-wrap');
			if (!wrap) {
				var stage = modal.querySelector('.ah-pdf-modal__stage');
				if (!stage) return null;
				wrap = document.createElement('div');
				wrap.className = 'ah-pdf-modal__book-wrap';
				stage.appendChild(wrap);
			}
			return wrap;
		}

		function ensureBookEl() {
			var wrap = getBookWrap();
			if (!wrap) return null;
			var book = document.getElementById('ahFlipbook');
			if (!book || !wrap.contains(book)) {
				wrap.innerHTML = '';
				book = document.createElement('div');
				book.id = 'ahFlipbook';
				book.className = 'ah-pdf-modal__book';
				wrap.appendChild(book);
			}
			return book;
		}

		function destroyFlip(keepImages) {
			if (pageFlip) {
				try { savedPage = pageFlip.getCurrentPageIndex(); } catch (e) { /* ignore */ }
				try { pageFlip.destroy(); } catch (e) { /* ignore */ }
				pageFlip = null;
			}
			var wrap = modal.querySelector('.ah-pdf-modal__book-wrap');
			if (wrap) wrap.innerHTML = '';
			if (!keepImages) {
				revokeUrls();
				lastImages = null;
				savedPage = 0;
				zoomLevel = 1;
				viewMode = 'single';
				syncViewModeLabel();
			}
		}

		function syncStageScroll() {
			var stage = modal.querySelector('.ah-pdf-modal__stage');
			if (!stage) return;
			requestAnimationFrame(function () {
				stage.scrollTop = 0;
				stage.scrollLeft = Math.max(0, (stage.scrollWidth - stage.clientWidth) / 2);
			});
		}

		function syncViewModeLabel() {
			if (viewModeLabel) {
				viewModeLabel.textContent = viewMode === 'spread' ? '2 hlm' : '1 hlm';
			}
		}

		function setPager(current, total) {
			if (!pager) return;
			if (!total) {
				pager.textContent = '—';
				return;
			}
			pager.textContent = (current + 1) + ' / ' + total;
		}

		function closeModal() {
			loadToken += 1;
			modal.setAttribute('hidden', 'hidden');
			modal.setAttribute('aria-hidden', 'true');
			modal.classList.remove('is-open');
			document.body.classList.remove('ah-pdf-open');
			destroyFlip();
			if (loading) loading.removeAttribute('hidden');
			if (errorEl) errorEl.setAttribute('hidden', 'hidden');
			if (lastFocus && lastFocus.focus) lastFocus.focus();
		}

		function openModal(title, downloadUrl) {
			lastFocus = document.activeElement;
			if (titleEl) titleEl.textContent = title || 'PDF';
			if (download) download.setAttribute('href', downloadUrl);
			if (errorLink) errorLink.setAttribute('href', downloadUrl);
			if (loading) loading.removeAttribute('hidden');
			if (errorEl) errorEl.setAttribute('hidden', 'hidden');
			ensureBookEl();
			modal.removeAttribute('hidden');
			modal.setAttribute('aria-hidden', 'false');
			modal.classList.add('is-open');
			document.body.classList.add('ah-pdf-open');
		}

		function showError() {
			if (loading) loading.setAttribute('hidden', 'hidden');
			if (errorEl) errorEl.removeAttribute('hidden');
		}

		function getBookSize() {
			var stage = modal.querySelector('.ah-pdf-modal__stage');
			var pad = 12;
			var w = Math.max(200, (stage ? stage.clientWidth : window.innerWidth) - pad);
			var h = Math.max(280, (stage ? stage.clientHeight : window.innerHeight) - pad);
			var isMobile = window.innerWidth < 768;
			var mode = isMobile ? 'single' : viewMode;
			var pageW;
			var pageH;

			if (mode === 'spread') {
				pageW = Math.min(440, Math.floor(w / 2));
				pageH = Math.round(pageW * 1.414);
				if (pageH > h) {
					pageH = h;
					pageW = Math.round(pageH / 1.414);
				}
				if (pageW * 2 > w) {
					pageW = Math.floor(w / 2);
					pageH = Math.min(h, Math.round(pageW * 1.414));
				}
			} else {
				// One large page — fill stage height for readable article text
				pageH = h;
				pageW = Math.round(pageH / 1.414);
				if (pageW > w) {
					pageW = w;
					pageH = Math.round(pageW * 1.414);
					if (pageH > h) {
						pageH = h;
						pageW = Math.round(pageH / 1.414);
					}
				}
			}

			pageW = Math.max(180, Math.round(pageW * zoomLevel));
			pageH = Math.max(260, Math.round(pageH * zoomLevel));
			return { width: pageW, height: pageH, isMobile: isMobile, mode: mode };
		}

		function renderPdfPages(pdf) {
			// High DPI so text stays sharp when fitted to the modal
			var dpr = window.devicePixelRatio || 1;
			var scale = window.innerWidth < 768
				? Math.min(2.2, 1.6 * dpr)
				: Math.min(2.8, 2.0 * dpr);
			var maxPages = Math.min(pdf.numPages, 60);
			var tasks = [];

			for (var i = 1; i <= maxPages; i++) {
				(function (pageNum) {
					tasks.push(
						pdf.getPage(pageNum).then(function (page) {
							var viewport = page.getViewport({ scale: scale });
							var canvas = document.createElement('canvas');
							var ctx = canvas.getContext('2d', { alpha: false });
							canvas.width = Math.floor(viewport.width);
							canvas.height = Math.floor(viewport.height);
							ctx.fillStyle = '#ffffff';
							ctx.fillRect(0, 0, canvas.width, canvas.height);
							return page
								.render({ canvasContext: ctx, viewport: viewport })
								.promise
								.then(function () {
									return new Promise(function (resolve) {
										if (!canvas.toBlob) {
											resolve(canvas.toDataURL('image/jpeg', 0.94));
											return;
										}
										canvas.toBlob(function (blob) {
											if (!blob) {
												resolve(canvas.toDataURL('image/jpeg', 0.94));
												return;
											}
											var url = URL.createObjectURL(blob);
											objectUrls.push(url);
											resolve(url);
										}, 'image/jpeg', 0.94);
									});
								});
						})
					);
				})(i);
			}

			return Promise.all(tasks);
		}

		function mountFlipbook(images) {
			var book = ensureBookEl();
			if (!book) throw new Error('no book container');

			lastImages = images;
			var size = getBookSize();
			var useSingle = size.mode === 'single' || images.length < 2;
			var startAt = Math.max(0, Math.min(savedPage, images.length - 1));

			if (pageFlip) {
				try { savedPage = pageFlip.getCurrentPageIndex(); } catch (e) { /* ignore */ }
				try { pageFlip.destroy(); } catch (e) { /* ignore */ }
				pageFlip = null;
				book = ensureBookEl();
				startAt = Math.max(0, Math.min(savedPage, images.length - 1));
			}

			book.innerHTML = '';
			book.style.width = size.width + 'px';
			book.style.maxWidth = 'none';

			pageFlip = new St.PageFlip(book, {
				width: size.width,
				height: size.height,
				size: 'fixed',
				minWidth: size.width,
				maxWidth: size.width,
				minHeight: size.height,
				maxHeight: size.height,
				drawShadow: true,
				flippingTime: 900,
				usePortrait: useSingle,
				startPage: startAt,
				autoSize: false,
				maxShadowOpacity: 0.45,
				showCover: false,
				mobileScrollSupport: true,
				swipeDistance: 25,
				clickEventForward: true,
				useMouseEvents: true,
				showPageCorners: !useSingle,
				disableFlipByClick: false
			});

			pageFlip.loadFromImages(images);
			pageFlip.on('flip', function (e) {
				savedPage = e.data;
				setPager(e.data, pageFlip.getPageCount());
			});
			setPager(startAt, pageFlip.getPageCount());
			syncViewModeLabel();
			syncStageScroll();
			if (loading) loading.setAttribute('hidden', 'hidden');
		}

		function remountKeepImages() {
			if (!lastImages || !lastImages.length) return;
			mountFlipbook(lastImages);
		}

		function loadFlipbook(downloadUrl) {
			var token = ++loadToken;
			destroyFlip(false);
			ensureBookEl();
			if (loading) loading.removeAttribute('hidden');
			if (errorEl) errorEl.setAttribute('hidden', 'hidden');
			setPager(0, 0);

			pdfjsLib
				.getDocument({
					url: downloadUrl,
					withCredentials: true,
					cMapUrl: 'https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/cmaps/',
					cMapPacked: true
				})
				.promise
				.then(function (pdf) {
					if (token !== loadToken) return null;
					return renderPdfPages(pdf);
				})
				.then(function (images) {
					if (token !== loadToken || !images) return;
					if (!images.length) throw new Error('empty');
					mountFlipbook(images);
				})
				.catch(function (err) {
					if (token !== loadToken) return;
					console.warn('[audhighasu] flipbook error', err);
					showError();
				});
		}

		document.addEventListener('click', function (e) {
			var link = closest(e.target, 'a.obj_galley_link.pdf');
			if (!link) return;
			if (link.classList.contains('restricted')) return;
			if (e.metaKey || e.ctrlKey || e.shiftKey || e.altKey || e.button === 1) return;

			e.preventDefault();
			e.stopPropagation();

			var viewUrl = link.getAttribute('href');
			var downloadUrl = toDownloadUrl(viewUrl);
			var label = (link.textContent || 'PDF').trim();
			var titleNode = document.querySelector('.ah-article-head__title, .obj_article_details .page_title, .page_title, h1');
			var articleTitle = titleNode ? titleNode.textContent.trim() : '';
			var title = articleTitle || label;

			openModal(title, downloadUrl);
			loadFlipbook(downloadUrl);
		}, true);

		modal.querySelectorAll('[data-ah-pdf-close]').forEach(function (el) {
			el.addEventListener('click', function (e) {
				e.preventDefault();
				closeModal();
			});
		});

		var prevBtn = document.getElementById('ahPdfPrev');
		var nextBtn = document.getElementById('ahPdfNext');
		var zoomInBtn = document.getElementById('ahPdfZoomIn');
		var zoomOutBtn = document.getElementById('ahPdfZoomOut');
		var viewModeBtn = document.getElementById('ahPdfViewMode');
		if (prevBtn) {
			prevBtn.addEventListener('click', function () {
				if (pageFlip) pageFlip.flipPrev();
			});
		}
		if (nextBtn) {
			nextBtn.addEventListener('click', function () {
				if (pageFlip) pageFlip.flipNext();
			});
		}
		if (zoomInBtn) {
			zoomInBtn.addEventListener('click', function () {
				if (zoomLevel >= 3) return;
				zoomLevel = Math.round((zoomLevel + 0.25) * 100) / 100;
				remountKeepImages();
			});
		}
		if (zoomOutBtn) {
			zoomOutBtn.addEventListener('click', function () {
				if (zoomLevel <= 0.7) return;
				zoomLevel = Math.round((zoomLevel - 0.25) * 100) / 100;
				remountKeepImages();
			});
		}
		if (viewModeBtn) {
			viewModeBtn.addEventListener('click', function () {
				viewMode = viewMode === 'single' ? 'spread' : 'single';
				zoomLevel = 1;
				syncViewModeLabel();
				remountKeepImages();
			});
		}

		document.addEventListener('keydown', function (e) {
			if (!modal.classList.contains('is-open')) return;
			if (e.key === 'Escape') closeModal();
			if (e.key === 'ArrowLeft' && pageFlip) pageFlip.flipPrev();
			if (e.key === 'ArrowRight' && pageFlip) pageFlip.flipNext();
		});

		window.addEventListener('resize', function () {
			if (!modal.classList.contains('is-open') || !pageFlip) return;
			try {
				if (typeof pageFlip.update === 'function') pageFlip.update();
			} catch (err) { /* ignore */ }
		});
	}

	function cssVar(name, fallback) {
		var v = getComputedStyle(document.documentElement).getPropertyValue(name).trim();
		return v || fallback;
	}

	function parseJsonAttr(el, name, fallback) {
		try {
			var raw = el.getAttribute(name);
			if (!raw) return fallback;
			return JSON.parse(raw);
		} catch (e) {
			return fallback;
		}
	}

	function initArticleMetricsCharts() {
		var wrap = document.querySelector('[data-ah-charts]');
		if (!wrap || typeof Chart === 'undefined') return;
		if (wrap.getAttribute('data-ah-charts-ready') === '1') return;
		wrap.setAttribute('data-ah-charts-ready', '1');

		var labels = parseJsonAttr(wrap, 'data-labels', []);
		var views = parseJsonAttr(wrap, 'data-views', []);
		var downloads = parseJsonAttr(wrap, 'data-downloads', []);
		var viewsTotal = parseInt(wrap.getAttribute('data-views-total'), 10) || 0;
		var downloadsTotal = parseInt(wrap.getAttribute('data-downloads-total'), 10) || 0;
		var labelViews = wrap.getAttribute('data-label-views') || 'Views';
		var labelDownloads = wrap.getAttribute('data-label-downloads') || 'Downloads';

		var primary = cssVar('--ah-primary', '#E85D04');
		var primaryDark = cssVar('--ah-primary-dark', '#C2410C');
		var muted = cssVar('--ah-muted', '#78716C');
		var ink = cssVar('--ah-ink', '#1C1917');
		var primaryRgb = cssVar('--ah-primary-rgb', '232, 93, 4');
		var viewsColor = '#A8A29E';
		var viewsHover = '#78716C';

		var trendEl = document.getElementById('ahChartTrend');
		if (trendEl) {
			new Chart(trendEl, {
				type: 'bar',
				data: {
					labels: labels,
					datasets: [
						{
							label: labelViews,
							data: views,
							backgroundColor: viewsColor,
							hoverBackgroundColor: viewsHover,
							borderRadius: 4,
							borderSkipped: false,
							maxBarThickness: 16
						},
						{
							label: labelDownloads,
							data: downloads,
							backgroundColor: primary,
							hoverBackgroundColor: primaryDark,
							borderRadius: 4,
							borderSkipped: false,
							maxBarThickness: 16
						}
					]
				},
				options: {
					responsive: true,
					maintainAspectRatio: false,
					interaction: { mode: 'index', intersect: false },
					plugins: {
						legend: {
							labels: {
								color: muted,
								usePointStyle: true,
								pointStyle: 'rectRounded',
								boxWidth: 10,
								padding: 14,
								font: { weight: '700', size: 11 }
							}
						},
						tooltip: {
							backgroundColor: ink,
							borderColor: primary,
							borderWidth: 1,
							cornerRadius: 6,
							padding: 10,
							callbacks: {
								label: function (ctx) {
									var v = ctx.parsed.y || 0;
									return ' ' + ctx.dataset.label + ': ' + v.toLocaleString();
								}
							}
						}
					},
					scales: {
						x: {
							grid: { display: false },
							ticks: { color: muted, font: { weight: '700', size: 10 } },
							border: { display: false }
						},
						y: {
							beginAtZero: true,
							grace: '10%',
							grid: { color: 'rgba(' + primaryRgb + ', 0.08)', drawBorder: false },
							ticks: { color: muted, precision: 0, font: { size: 11 } },
							border: { display: false }
						}
					}
				}
			});
		}

		var mixEl = document.getElementById('ahChartMix');
		if (mixEl) {
			var mixData = [viewsTotal, downloadsTotal];
			if (mixData[0] + mixData[1] === 0) {
				mixData = [1, 0];
			}
			var mixTotal = mixData[0] + mixData[1];
			new Chart(mixEl, {
				type: 'doughnut',
				data: {
					labels: [labelViews, labelDownloads],
					datasets: [{
						data: mixData,
						backgroundColor: [viewsColor, primary],
						hoverBackgroundColor: [viewsHover, primaryDark],
						borderWidth: 3,
						borderColor: '#fff',
						hoverOffset: 6
					}]
				},
				options: {
					responsive: true,
					maintainAspectRatio: false,
					cutout: '68%',
					plugins: {
						legend: {
							position: 'bottom',
							labels: {
								color: muted,
								usePointStyle: true,
								pointStyle: 'circle',
								padding: 14,
								font: { weight: '700', size: 11 }
							}
						},
						tooltip: {
							backgroundColor: ink,
							borderColor: primary,
							borderWidth: 1,
							cornerRadius: 6,
							padding: 10,
							callbacks: {
								label: function (ctx) {
									var v = ctx.parsed || 0;
									var pct = mixTotal ? Math.round((v / mixTotal) * 100) : 0;
									return ' ' + ctx.label + ': ' + v.toLocaleString() + ' (' + pct + '%)';
								}
							}
						}
					}
				},
				plugins: [{
					id: 'ahMixCenter',
					afterDraw: function (chart) {
						var meta = chart.getDatasetMeta(0);
						if (!meta || !meta.data || !meta.data[0]) return;
						var x = meta.data[0].x;
						var y = meta.data[0].y;
						var ctx = chart.ctx;
						ctx.save();
						ctx.textAlign = 'center';
						ctx.textBaseline = 'middle';
						ctx.fillStyle = muted;
						ctx.font = '700 10px system-ui, sans-serif';
						ctx.fillText('TOTAL', x, y - 12);
						ctx.fillStyle = ink;
						ctx.font = '700 22px Georgia, serif';
						ctx.fillText(mixTotal.toLocaleString(), x, y + 8);
						ctx.restore();
					}
				}]
			});
		}
	}

	function boot() {
		initPrimarySubmenus();
		initMobileNav();
		initLanguageToggles();
		initPasswordPeek();
		initPdfFlipbook();
		initArticleMetricsCharts();
		// PDF.js / PageFlip / Chart.js may arrive slightly after theme script
		window.setTimeout(initPdfFlipbook, 120);
		window.setTimeout(initPdfFlipbook, 450);
		window.setTimeout(initArticleMetricsCharts, 120);
		window.setTimeout(initArticleMetricsCharts, 450);
	}

	if (document.readyState === 'loading') {
		document.addEventListener('DOMContentLoaded', boot);
	} else {
		boot();
	}
	// Default theme applies Bootstrap dropdowns on ready/resize — undo after it.
	window.setTimeout(initPrimarySubmenus, 0);
	window.setTimeout(initPrimarySubmenus, 150);
	window.addEventListener('resize', function () {
		window.clearTimeout(window.__ahNavFixT);
		window.__ahNavFixT = window.setTimeout(initPrimarySubmenus, 60);
	});
})();
