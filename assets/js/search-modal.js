// Search Modal - macOS Spotlight-style search
import { fuseOpts } from '@params';

(function () {
    'use strict';
    var fuse = null;
    var indexLoaded = false;
    var activeIndex = -1;

    // --- DOM Creation ---
    var backdrop = document.createElement('div');
    backdrop.className = 'search-modal-backdrop';

    var modal = document.createElement('div');
    modal.className = 'search-modal';
    modal.setAttribute('role', 'dialog');
    modal.setAttribute('aria-label', 'Search');

    modal.innerHTML =
        '<div class="search-modal-header">' +
            '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>' +
            '<input class="search-modal-input" type="text" placeholder="Search articles..." autocomplete="off" spellcheck="false">' +
            '<button class="search-modal-close" aria-label="Close search">esc</button>' +
        '</div>' +
        '<div class="search-modal-results"></div>' +
        '<div class="search-modal-footer">' +
            '<div class="search-modal-footer-keys">' +
                '<span><kbd>&uarr;</kbd><kbd>&darr;</kbd> navigate</span>' +
                '<span><kbd>&crarr;</kbd> open</span>' +
                '<span><kbd>esc</kbd> close</span>' +
            '</div>' +
        '</div>';

    document.body.appendChild(backdrop);
    document.body.appendChild(modal);

    var input = modal.querySelector('.search-modal-input');
    var resultsContainer = modal.querySelector('.search-modal-results');
    var closeBtn = modal.querySelector('.search-modal-close');

    // --- Index Loading ---
    function getIndexUrl() {
        var base = document.querySelector('link[rel="canonical"]');
        if (base) {
            var url = new URL(base.href);
            return url.origin + '/index.json';
        }
        return '/index.json';
    }

    function loadIndexFetch(callback) {
        if (indexLoaded) {
            if (callback) callback();
            return;
        }

        fetch(getIndexUrl())
            .then(function (response) { return response.json(); })
            .then(function (data) {
                var opts = {
                    isCaseSensitive: fuseOpts.isCaseSensitive || false,
                    shouldSort: fuseOpts.shouldSort !== false,
                    location: fuseOpts.location || 0,
                    distance: fuseOpts.distance || 1000,
                    threshold: fuseOpts.threshold || 0.4,
                    minMatchCharLength: fuseOpts.minMatchCharLength || 0,
                    keys: fuseOpts.keys || ['title', 'permalink', 'summary', 'content']
                };
                fuse = new Fuse(data, opts);
                indexLoaded = true;
                if (callback) callback();
            })
            .catch(function () {
                showEmpty('Failed to load search index.');
            });
    }

    // --- Open / Close ---
    function openModal() {
        backdrop.classList.add('open');
        modal.classList.add('open');
        document.body.classList.add('search-modal-open');
        input.value = '';
        resultsContainer.innerHTML = '';
        activeIndex = -1;

        // Close mobile hamburger menu if open
        var menuToggle = document.getElementById('menu-toggle');
        var menu = document.getElementById('menu');
        if (menuToggle && menu && menu.classList.contains('menu-open')) {
            menu.classList.remove('menu-open');
            menuToggle.setAttribute('aria-expanded', 'false');
            document.body.classList.remove('menu-open');
        }

        setTimeout(function () { input.focus(); }, 50);

        loadIndexFetch(function () {
            if (input.value.trim()) {
                doSearch(input.value.trim());
            }
        });
    }

    function closeModal() {
        backdrop.classList.remove('open');
        modal.classList.remove('open');
        document.body.classList.remove('search-modal-open');
        activeIndex = -1;
    }

    function isOpen() {
        return modal.classList.contains('open');
    }

    // --- Search ---
    function doSearch(query) {
        if (!fuse) {
            showEmpty('Loading...');
            return;
        }

        if (!query) {
            resultsContainer.innerHTML = '';
            activeIndex = -1;
            return;
        }

        var results = fuse.search(query, { limit: 20 });

        if (results.length === 0) {
            showEmpty('No results found for "' + escapeHtml(query) + '"');
            return;
        }

        activeIndex = -1;
        var html = '';
        for (var i = 0; i < results.length; i++) {
            var item = results[i].item;
            var title = escapeHtml(stripHtml(item.title || ''));
            var summary = escapeHtml(stripHtml(item.summary || '').substring(0, 150));
            html +=
                '<a class="search-modal-result" href="' + escapeHtml(item.permalink) + '" data-index="' + i + '">' +
                    '<div class="search-modal-result-title">' + title + '</div>' +
                    (summary ? '<div class="search-modal-result-summary">' + summary + '</div>' : '') +
                '</a>';
        }
        resultsContainer.innerHTML = html;
    }

    function showEmpty(msg) {
        resultsContainer.innerHTML = '<div class="search-modal-empty">' + msg + '</div>';
    }

    function escapeHtml(str) {
        var div = document.createElement('div');
        div.appendChild(document.createTextNode(str));
        return div.innerHTML;
    }

    function stripHtml(str) {
        var div = document.createElement('div');
        div.innerHTML = str;
        return (div.textContent || div.innerText || '').replace(/\s+/g, ' ').trim();
    }

    // --- Keyboard Navigation ---
    function getResultLinks() {
        return resultsContainer.querySelectorAll('.search-modal-result');
    }

    function setActive(index) {
        var links = getResultLinks();
        if (links.length === 0) return;

        // Remove previous active
        for (var i = 0; i < links.length; i++) {
            links[i].classList.remove('active');
        }

        if (index < 0) index = links.length - 1;
        if (index >= links.length) index = 0;

        activeIndex = index;
        links[activeIndex].classList.add('active');
        links[activeIndex].scrollIntoView({ block: 'nearest' });
    }

    // --- Event Listeners ---

    // Search input
    input.addEventListener('input', function () {
        doSearch(input.value.trim());
    });

    // Close button
    closeBtn.addEventListener('click', function (e) {
        e.preventDefault();
        closeModal();
    });

    // Backdrop click
    backdrop.addEventListener('click', closeModal);

    // Prevent modal click from closing
    modal.addEventListener('click', function (e) {
        e.stopPropagation();
    });

    // Keyboard shortcuts
    document.addEventListener('keydown', function (e) {
        // Cmd+K / Ctrl+K to open
        if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
            e.preventDefault();
            if (isOpen()) {
                closeModal();
            } else {
                openModal();
            }
            return;
        }

        if (!isOpen()) return;

        // Escape to close
        if (e.key === 'Escape') {
            e.preventDefault();
            closeModal();
            return;
        }

        // Arrow navigation
        if (e.key === 'ArrowDown') {
            e.preventDefault();
            setActive(activeIndex + 1);
            return;
        }

        if (e.key === 'ArrowUp') {
            e.preventDefault();
            setActive(activeIndex - 1);
            return;
        }

        // Enter to navigate
        if (e.key === 'Enter') {
            var links = getResultLinks();
            if (activeIndex >= 0 && activeIndex < links.length) {
                e.preventDefault();
                window.location.href = links[activeIndex].getAttribute('href');
            }
            return;
        }
    });

    // Intercept search nav link clicks
    document.addEventListener('click', function (e) {
        var link = e.target.closest('a[href*="/search"]');
        if (link) {
            e.preventDefault();
            openModal();
        }
    });

    // Add keyboard shortcut badge to search nav links
    var isMac = navigator.platform.toUpperCase().indexOf('MAC') >= 0;
    document.querySelectorAll('#menu a[href*="/search"]').forEach(function (link) {
        var badge = document.createElement('span');
        badge.className = 'search-shortcut-badge';
        badge.textContent = isMac ? '\u2318K' : 'Ctrl+K';
        link.querySelector('span').appendChild(badge);
    });

    // Populate homepage search trigger kbd
    document.querySelectorAll('.search-trigger-kbd').forEach(function (kbd) {
        kbd.textContent = isMac ? '\u2318K' : 'Ctrl+K';
    });

})();
