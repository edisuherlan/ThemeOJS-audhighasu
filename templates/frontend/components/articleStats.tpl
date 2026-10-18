{**
 * Audhighasu — Research Folio article engagement metrics
 * Author  : Edi Suherlan | audhighasu.com
*}
{if $ahArticleMetrics}
	<section class="ah-metrics item" aria-label="{translate|escape key="plugins.themes.audhighasu.stats.infographic"}">
		<header class="ah-metrics__head">
			<p class="ah-metrics__kicker">{translate key="plugins.themes.audhighasu.stats.infographic"}</p>
			<h2 class="ah-metrics__title">{translate key="plugins.themes.audhighasu.stats.engagement"}</h2>
			<p class="ah-metrics__hint">{translate key="plugins.themes.audhighasu.stats.hint"}</p>
		</header>

		<div class="ah-metrics__kpis">
			<div class="ah-metric-kpi ah-metric-kpi--views">
				<span class="ah-metric-kpi__label">{translate key="plugins.themes.audhighasu.stats.views"}</span>
				<strong class="ah-metric-kpi__value">{$ahArticleMetrics.views|escape}</strong>
				<span class="ah-metric-kpi__sub">{translate key="plugins.themes.audhighasu.stats.abstractViews"}</span>
			</div>
			<div class="ah-metric-kpi ah-metric-kpi--downloads">
				<span class="ah-metric-kpi__label">{translate key="plugins.themes.audhighasu.stats.downloads"}</span>
				<strong class="ah-metric-kpi__value">{$ahArticleMetrics.downloads|escape}</strong>
				<span class="ah-metric-kpi__sub">{translate key="plugins.themes.audhighasu.stats.fileDownloads"}</span>
			</div>
			<div class="ah-metric-kpi ah-metric-kpi--total">
				<span class="ah-metric-kpi__label">{translate key="plugins.themes.audhighasu.stats.total"}</span>
				<strong class="ah-metric-kpi__value">{$ahArticleMetrics.total|escape}</strong>
				<span class="ah-metric-kpi__sub">{translate key="plugins.themes.audhighasu.stats.interactions"}</span>
			</div>
		</div>

		<div class="ah-metrics__split" aria-hidden="true">
			<div class="ah-metrics__split-bar">
				<span class="ah-metrics__split-views" style="width: {$ahArticleMetrics.viewsPct}%;"></span>
				<span class="ah-metrics__split-downloads" style="width: {$ahArticleMetrics.downloadsPct}%;"></span>
			</div>
			<div class="ah-metrics__split-legend">
				<span><i class="views"></i> {translate key="plugins.themes.audhighasu.stats.views"} {$ahArticleMetrics.viewsPct}%</span>
				<span><i class="downloads"></i> {translate key="plugins.themes.audhighasu.stats.downloads"} {$ahArticleMetrics.downloadsPct}%</span>
			</div>
		</div>

		<div class="ah-metrics__charts"
			data-ah-charts
			data-labels="{$ahArticleMetrics.labelsJson|escape}"
			data-views="{$ahArticleMetrics.viewsJson|escape}"
			data-downloads="{$ahArticleMetrics.downloadsJson|escape}"
			data-views-total="{$ahArticleMetrics.views|escape}"
			data-downloads-total="{$ahArticleMetrics.downloads|escape}"
			data-pdf="{$ahArticleMetrics.pdf|escape}"
			data-html="{$ahArticleMetrics.html|escape}"
			data-other="{$ahArticleMetrics.mixOther|escape}"
			data-label-views="{translate|escape key="plugins.themes.audhighasu.stats.views"}"
			data-label-downloads="{translate|escape key="plugins.themes.audhighasu.stats.downloads"}"
			data-label-pdf="PDF"
			data-label-html="HTML"
			data-label-other="{translate|escape key="plugins.themes.audhighasu.stats.otherFiles"}"
		>
			<div class="ah-chart-card ah-chart-card--trend">
				<p class="ah-chart-card__kicker">{translate key="plugins.themes.audhighasu.stats.trendKicker"}</p>
				<h3 class="ah-chart-card__title">{translate key="plugins.themes.audhighasu.stats.trend"}</h3>
				<div class="ah-chart-card__canvas">
					<canvas id="ahChartTrend" height="220"></canvas>
				</div>
			</div>
			<div class="ah-chart-card ah-chart-card--mix">
				<p class="ah-chart-card__kicker">{translate key="plugins.themes.audhighasu.stats.mixKicker"}</p>
				<h3 class="ah-chart-card__title">{translate key="plugins.themes.audhighasu.stats.mix"}</h3>
				<div class="ah-chart-card__canvas ah-chart-card__canvas--mix">
					<canvas id="ahChartMix" height="220"></canvas>
				</div>
				{if $ahArticleMetrics.downloads > 0}
					<div class="ah-chart-card__files">
						{if $ahArticleMetrics.pdf > 0}
							<span class="ah-chart-card__file">PDF <strong>{$ahArticleMetrics.pdf|escape}</strong></span>
						{/if}
						{if $ahArticleMetrics.html > 0}
							<span class="ah-chart-card__file">HTML <strong>{$ahArticleMetrics.html|escape}</strong></span>
						{/if}
						{if $ahArticleMetrics.mixOther > 0}
							<span class="ah-chart-card__file">{translate key="plugins.themes.audhighasu.stats.otherFiles"} <strong>{$ahArticleMetrics.mixOther|escape}</strong></span>
						{/if}
					</div>
				{/if}
			</div>
		</div>
	</section>
{/if}
