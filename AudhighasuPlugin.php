<?php

/**
 * @file plugins/themes/audhighasu/AudhighasuPlugin.php
 *
 * @class AudhighasuPlugin
 * @brief Free research-folio theme — scholarly masthead + citation layout
 *
 * Author     : Edi Suherlan
 * Company    : audhighasu.com
 * Contact    : audhighasu@gmail.com
 *
 * Licensed under GNU GPL v3 (required for OJS plugin compatibility).
 * Distributed free as a promotional edition by Audhighasu.
 */

namespace APP\plugins\themes\audhighasu;

use APP\core\Application;
use APP\facades\Repo;
use APP\template\TemplateManager;
use Illuminate\Support\Facades\Cache;
use PKP\core\PKPSessionGuard;
use PKP\facades\Locale;
use PKP\i18n\LocaleMetadata;
use PKP\plugins\Hook;
use PKP\statistics\PKPStatisticsHelper;

class AudhighasuPlugin extends \PKP\plugins\ThemePlugin
{
    public function init()
    {
        $this->setParent('defaultthemeplugin');

        Hook::add('TemplateManager::display', $this->assignFrontendData(...));

        $this->addOption('primaryColour', 'FieldColor', [
            'label' => __('plugins.themes.audhighasu.option.primaryColour.label'),
            'description' => __('plugins.themes.audhighasu.option.primaryColour.description'),
            'default' => '#E85D04',
        ]);

        $this->addOption('accentColour', 'FieldColor', [
            'label' => __('plugins.themes.audhighasu.option.accentColour.label'),
            'description' => __('plugins.themes.audhighasu.option.accentColour.description'),
            'default' => '#1C1917',
        ]);

        $this->addOption('showDescriptionInJournalIndex', 'FieldOptions', [
            'label' => __('manager.setup.contextSummary'),
            'options' => [
                [
                    'value' => true,
                    'label' => __('plugins.themes.audhighasu.option.showDescription.option'),
                ],
            ],
            'default' => true,
        ]);

        // Article folio: show download stats chart by default (bar)
        $this->addOption('displayStats', 'FieldOptions', [
            'type' => 'radio',
            'label' => __('plugins.themes.default.option.displayStats.label'),
            'options' => [
                [
                    'value' => 'none',
                    'label' => __('plugins.themes.default.option.displayStats.none'),
                ],
                [
                    'value' => 'bar',
                    'label' => __('plugins.themes.default.option.displayStats.bar'),
                ],
                [
                    'value' => 'line',
                    'label' => __('plugins.themes.default.option.displayStats.line'),
                ],
            ],
            'default' => 'bar',
        ]);

        $primary = $this->getOption('primaryColour') ?: '#E85D04';
        $accent = $this->getOption('accentColour') ?: '#1C1917';
        // Migrate earlier navy/gold promo defaults to the orange folio palette
        if (in_array(strtoupper((string) $primary), ['#1B2A4A', '#152238'], true)) {
            $primary = '#E85D04';
        }
        if (in_array(strtoupper((string) $accent), ['#B8860B', '#C5A46A'], true)) {
            $accent = '#1C1917';
        }
        if (!preg_match('/^#[0-9a-fA-F]{1,6}$/', (string) $primary)) {
            $primary = '#E85D04';
        }
        if (!preg_match('/^#[0-9a-fA-F]{1,6}$/', (string) $accent)) {
            $accent = '#1C1917';
        }

        $primaryDark = $this->darkenHex($primary, 18);
        $primaryLight = $this->lightenHex($primary, 22);
        $primarySoft = $this->lightenHex($primary, 42);
        $primaryRgb = $this->hexToRgbChannels($primary);
        $accentRgb = $this->hexToRgbChannels($accent);
        $ink = '#1C1917';
        $muted = '#78716C';
        $line = '#F0E4D8';
        $bg = '#FFF7ED';
        $surface = '#FFFFFF';
        $rule = $primary;

        $this->addStyle(
            'audhighasu-fonts',
            'https://fonts.googleapis.com/css2?family=Libre+Baskerville:ital,wght@0,400;0,700;1,400&family=Source+Sans+3:wght@400;500;600;700&display=swap',
            ['baseUrl' => '']
        );

        $this->addStyle(
            'audhighasu-vars',
            ':root{' .
                '--ah-primary:' . $primary . ';' .
                '--ah-primary-dark:' . $primaryDark . ';' .
                '--ah-primary-light:' . $primaryLight . ';' .
                '--ah-primary-soft:' . $primarySoft . ';' .
                '--ah-primary-rgb:' . $primaryRgb . ';' .
                '--ah-accent:' . $accent . ';' .
                '--ah-accent-rgb:' . $accentRgb . ';' .
                '--ah-ink:' . $ink . ';' .
                '--ah-muted:' . $muted . ';' .
                '--ah-line:' . $line . ';' .
                '--ah-bg:' . $bg . ';' .
                '--ah-surface:' . $surface . ';' .
                '--ah-rule:' . $rule . ';' .
                '--ah-max:1120px;' .
                '--ah-font:"Source Sans 3",system-ui,sans-serif;' .
                '--ah-display:"Libre Baskerville",Georgia,"Times New Roman",serif;' .
                '--ah-shadow:0 14px 40px rgba(232,93,4,0.12);' .
                '--ah-shadow-soft:0 8px 24px rgba(28,25,23,0.06);' .
            '}',
            ['inline' => true]
        );

        $this->modifyStyle('stylesheet', [
            'addLessVariables' => '@bg-base:' . $primary . ';',
        ]);

        [$page] = $this->getRequestedPageOp();
        if ($page === 'article' || $page === 'issue') {
            $this->addStyle('audhighasu-pdf', 'styles/pdf-flipbook.css?v=20261018r');
            $this->addScript(
                'pdfjs',
                'https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.min.js',
                ['baseUrl' => '']
            );
            $this->addScript(
                'page-flip',
                'https://cdn.jsdelivr.net/npm/page-flip@2.0.7/dist/js/page-flip.browser.js',
                ['baseUrl' => '']
            );
        }
        if ($page === 'article') {
            $request = Application::get()->getRequest();
            $this->addScript(
                'chartJS',
                $request->getBaseUrl() . '/js/build/chart.js/chart.umd.js',
                ['baseUrl' => '']
            );
        }

        $this->addStyle('audhighasu', 'styles/main.css?v=20261018z');
        $this->addScript('audhighasu', 'js/main.js?v=20261018z');
        $this->addMenuArea(['primary', 'user']);
    }

    /**
     * @return array{0:string,1:string}
     */
    private function getRequestedPageOp(): array
    {
        try {
            $request = Application::get()->getRequest();
            $router = $request?->getRouter();
            if ($router && method_exists($router, 'getRequestedPage')) {
                return [
                    (string) $router->getRequestedPage($request),
                    (string) $router->getRequestedOp($request),
                ];
            }
        } catch (\Throwable $e) {
        }
        return ['', ''];
    }

    /**
     * Prefer warm orange bars/lines for Chart.js usage graphs.
     */
    protected function getUsageStatsDisplayColor(int $num): string
    {
        return '232, 93, 4';
    }

    /**
     * Folio theme always exposes a chart (bar by default) even if the parent
     * Default theme option is still set to "none".
     */
    public function getOption($name)
    {
        $value = parent::getOption($name);
        if ($name === 'displayStats') {
            if ($value === 'line' || $value === 'bar') {
                return $value;
            }
            return 'bar';
        }
        return $value;
    }

    public function getDisplayName()
    {
        return __('plugins.themes.audhighasu.name');
    }

    public function getDescription()
    {
        return __('plugins.themes.audhighasu.description');
    }

    public function getContextSpecificPluginSettingsFile()
    {
        return $this->getPluginPath() . '/settings.xml';
    }

    public function getInstallSitePluginSettingsFile()
    {
        return $this->getPluginPath() . '/settings.xml';
    }

    public function saveOption($name, $value, $contextId = null)
    {
        if (in_array($name, ['primaryColour', 'accentColour'], true)
            && !preg_match('/^#[0-9a-fA-F]{1,6}$/', (string) $value)
        ) {
            $value = $name === 'accentColour' ? '#1C1917' : '#E85D04';
        }
        parent::saveOption($name, $value, $contextId);
    }

    public function assignFrontendData(string $hookName, array $args): bool
    {
        /** @var TemplateManager $templateMgr */
        $templateMgr = $args[0];
        $request = Application::get()->getRequest();

        if (PKPSessionGuard::isSessionDisable()) {
            $locales = Locale::getFormattedDisplayNames(null, null, LocaleMetadata::LANGUAGE_LOCALE_ONLY);
        } else {
            $context = $request->getContext();
            $locales = Locale::getFormattedDisplayNames(
                $context
                    ? $context->getSupportedLocales()
                    : $request->getSite()->getSupportedLocales(),
                Locale::getLocales(),
                LocaleMetadata::LANGUAGE_LOCALE_ONLY
            );
        }

        $context = $request->getContext();
        $stats = ['articles' => 0, 'issues' => 0, 'authors' => 0];
        $latestArticles = [];

        if ($context) {
            try {
                $stats['articles'] = Repo::submission()->getCollector()
                    ->filterByContextIds([$context->getId()])
                    ->filterByStatus([\PKP\submission\PKPSubmission::STATUS_PUBLISHED])
                    ->getCount();
                $stats['issues'] = Repo::issue()->getCollector()
                    ->filterByContextIds([$context->getId()])
                    ->filterByPublished(true)
                    ->getCount();
            } catch (\Throwable $e) {
            }

            try {
                $published = Repo::submission()->getCollector()
                    ->filterByContextIds([$context->getId()])
                    ->filterByStatus([\PKP\submission\PKPSubmission::STATUS_PUBLISHED])
                    ->getMany()
                    ->values()
                    ->all();

                usort($published, static function ($a, $b) {
                    $da = is_object($a) ? $a->getCurrentPublication()?->getData('datePublished') : null;
                    $db = is_object($b) ? $b->getCurrentPublication()?->getData('datePublished') : null;
                    return strcmp((string) $db, (string) $da);
                });

                $authorKeys = [];
                $seenIds = [];
                foreach ($published as $submission) {
                    if (!is_object($submission) || !method_exists($submission, 'getId')) {
                        continue;
                    }
                    $id = (int) $submission->getId();
                    if (isset($seenIds[$id])) {
                        continue;
                    }
                    $seenIds[$id] = true;
                    $pub = $submission->getCurrentPublication();
                    if (!$pub) {
                        continue;
                    }
                    if (count($latestArticles) < 8) {
                        $latestArticles[] = $submission;
                    }
                    foreach ((array) $pub->getData('authors') as $author) {
                        if (!is_object($author)) {
                            continue;
                        }
                        $given = method_exists($author, 'getLocalizedGivenName') ? (string) $author->getLocalizedGivenName() : '';
                        $family = method_exists($author, 'getLocalizedFamilyName') ? (string) $author->getLocalizedFamilyName() : '';
                        $key = mb_strtolower(trim($given . '|' . $family));
                        if ($key !== '|') {
                            $authorKeys[$key] = true;
                        }
                    }
                }
                $stats['authors'] = count($authorKeys) ?: max(1, (int) round($stats['articles'] * 1.4));
            } catch (\Throwable $e) {
            }
        }

        $ahArticleMetrics = null;
        [$page] = $this->getRequestedPageOp();
        if ($page === 'article' && $context) {
            $article = $templateMgr->getTemplateVars('article');
            if (is_object($article) && method_exists($article, 'getId')) {
                $ahArticleMetrics = $this->getArticleMetrics((int) $article->getId(), (int) $context->getId());
            }
        }

        $templateMgr->assign([
            'ahEnableLanguageToggle' => count($locales) > 1,
            'ahLanguageToggleLocales' => $locales,
            'ahStats' => $stats,
            'ahLatestArticles' => $latestArticles,
            // Reliable under themeDemoBar (activeTheme can be stale/null)
            'ahTheme' => $this,
            'ahDisplayStats' => $this->getOption('displayStats') ?: 'bar',
            'ahArticleMetrics' => $ahArticleMetrics,
        ]);

        return false;
    }

    public function getArticleMetrics(int $submissionId, int $contextId): array
    {
        $cacheKey = "audhighasuMetricsV2-{$contextId}-{$submissionId}";
        try {
            return Cache::remember($cacheKey, 60 * 30, function () use ($submissionId, $contextId) {
                return $this->buildArticleMetrics($submissionId, $contextId);
            });
        } catch (\Throwable $e) {
            return $this->buildArticleMetrics($submissionId, $contextId);
        }
    }

    private function buildArticleMetrics(int $submissionId, int $contextId): array
    {
        $empty = [
            'views' => 0,
            'downloads' => 0,
            'pdf' => 0,
            'html' => 0,
            'other' => 0,
            'supp' => 0,
            'mixOther' => 0,
            'total' => 0,
            'viewsPct' => 0,
            'downloadsPct' => 0,
            'hasData' => false,
            'labels' => [],
            'viewsSeries' => [],
            'downloadsSeries' => [],
            'labelsJson' => '[]',
            'viewsJson' => '[]',
            'downloadsJson' => '[]',
        ];

        try {
            /** @var \APP\services\StatsPublicationService $statsService */
            $statsService = app()->get('publicationStats');
            $byType = $statsService->getTotalsByType($submissionId, $contextId, null, null);
        } catch (\Throwable $e) {
            return $empty;
        }

        $views = (int) ($byType['abstract'] ?? 0);
        $pdf = (int) ($byType['pdf'] ?? 0);
        $html = (int) ($byType['html'] ?? 0);
        $other = (int) ($byType['other'] ?? 0);
        $supp = (int) ($byType['suppFileViews'] ?? 0);
        $downloads = $pdf + $html + $other + $supp;
        $timeline = $this->buildArticleTimeline($submissionId, $contextId);

        $total = $views + $downloads;
        $viewsPct = $total > 0 ? (int) round(($views / $total) * 100) : 0;
        $downloadsPct = $total > 0 ? (int) round(($downloads / $total) * 100) : 0;
        // Keep bar legend summing to 100 when rounding drifts.
        if ($total > 0 && ($viewsPct + $downloadsPct) !== 100) {
            $downloadsPct = 100 - $viewsPct;
        }

        return [
            'views' => $views,
            'downloads' => $downloads,
            'pdf' => $pdf,
            'html' => $html,
            'other' => $other,
            'supp' => $supp,
            'mixOther' => $other + $supp,
            'total' => $total,
            'viewsPct' => $viewsPct,
            'downloadsPct' => $downloadsPct,
            'hasData' => $total > 0 || !empty($timeline['labels']),
            'labels' => $timeline['labels'],
            'viewsSeries' => $timeline['views'],
            'downloadsSeries' => $timeline['downloads'],
            'labelsJson' => json_encode($timeline['labels'], JSON_UNESCAPED_UNICODE),
            'viewsJson' => json_encode($timeline['views']),
            'downloadsJson' => json_encode($timeline['downloads']),
        ];
    }

    private function buildArticleTimeline(int $submissionId, int $contextId): array
    {
        $labels = [];
        $views = [];
        $downloads = [];

        try {
            /** @var \APP\services\StatsPublicationService $statsService */
            $statsService = app()->get('publicationStats');
            $dateStart = (new \DateTimeImmutable('first day of -11 months'))->format('Y-m-d');
            $viewRows = $statsService->getTimeline(PKPStatisticsHelper::STATISTICS_DIMENSION_MONTH, [
                'contextIds' => [$contextId],
                'submissionIds' => [$submissionId],
                'assocTypes' => [Application::ASSOC_TYPE_SUBMISSION],
                'dateStart' => $dateStart,
            ]);
            $dlRows = $statsService->getTimeline(PKPStatisticsHelper::STATISTICS_DIMENSION_MONTH, [
                'contextIds' => [$contextId],
                'submissionIds' => [$submissionId],
                'assocTypes' => [Application::ASSOC_TYPE_SUBMISSION_FILE],
                'dateStart' => $dateStart,
            ]);
        } catch (\Throwable $e) {
            return ['labels' => [], 'views' => [], 'downloads' => []];
        }

        $mapViews = [];
        foreach ((array) $viewRows as $row) {
            $date = is_array($row) ? ($row['date'] ?? '') : (string) ($row->date ?? '');
            $value = (int) (is_array($row) ? ($row['value'] ?? 0) : ($row->value ?? 0));
            if ($date !== '') {
                $mapViews[substr($date, 0, 7)] = $value;
            }
        }
        $mapDl = [];
        foreach ((array) $dlRows as $row) {
            $date = is_array($row) ? ($row['date'] ?? '') : (string) ($row->date ?? '');
            $value = (int) (is_array($row) ? ($row['value'] ?? 0) : ($row->value ?? 0));
            if ($date !== '') {
                $mapDl[substr($date, 0, 7)] = $value;
            }
        }

        $cursor = new \DateTimeImmutable('first day of -11 months');
        $monthNames = explode(' ', (string) __('plugins.themes.default.displayStats.monthInitials'));
        for ($i = 0; $i < 12; $i++) {
            $key = $cursor->format('Y-m');
            $monthIndex = (int) $cursor->format('n') - 1;
            $labels[] = $monthNames[$monthIndex] ?? $cursor->format('M');
            $views[] = (int) ($mapViews[$key] ?? 0);
            $downloads[] = (int) ($mapDl[$key] ?? 0);
            $cursor = $cursor->modify('+1 month');
        }

        return ['labels' => $labels, 'views' => $views, 'downloads' => $downloads];
    }

    private function darkenHex(string $hex, int $percent): string
    {
        $hex = ltrim($hex, '#');
        if (strlen($hex) === 3) {
            $hex = $hex[0] . $hex[0] . $hex[1] . $hex[1] . $hex[2] . $hex[2];
        }
        $rgb = [
            hexdec(substr($hex, 0, 2)),
            hexdec(substr($hex, 2, 2)),
            hexdec(substr($hex, 4, 2)),
        ];
        foreach ($rgb as &$c) {
            $c = max(0, min(255, (int) round($c * (1 - $percent / 100))));
        }
        return sprintf('#%02x%02x%02x', $rgb[0], $rgb[1], $rgb[2]);
    }

    private function lightenHex(string $hex, int $percent): string
    {
        $hex = ltrim($hex, '#');
        if (strlen($hex) === 3) {
            $hex = $hex[0] . $hex[0] . $hex[1] . $hex[1] . $hex[2] . $hex[2];
        }
        $rgb = [
            hexdec(substr($hex, 0, 2)),
            hexdec(substr($hex, 2, 2)),
            hexdec(substr($hex, 4, 2)),
        ];
        foreach ($rgb as &$c) {
            $c = max(0, min(255, (int) round($c + (255 - $c) * ($percent / 100))));
        }
        return sprintf('#%02x%02x%02x', $rgb[0], $rgb[1], $rgb[2]);
    }

    private function hexToRgbChannels(string $hex): string
    {
        $hex = ltrim($hex, '#');
        if (strlen($hex) === 3) {
            $hex = $hex[0] . $hex[0] . $hex[1] . $hex[1] . $hex[2] . $hex[2];
        }
        return sprintf(
            '%d, %d, %d',
            hexdec(substr($hex, 0, 2)),
            hexdec(substr($hex, 2, 2)),
            hexdec(substr($hex, 4, 2))
        );
    }
}
