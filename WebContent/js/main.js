/* The Last Pawn Chess Academy — Main JavaScript */

// === NAVBAR: Scroll effect + Hamburger ===
document.addEventListener('DOMContentLoaded', function () {
    const navbar = document.querySelector('.navbar');
    const hamburger = document.querySelector('.nav-hamburger');
    const navLinks = document.querySelector('.nav-links');
    const navButtons = document.querySelector('.nav-buttons');

    // Scroll class
    if (navbar) {
        window.addEventListener('scroll', function () {
            if (window.scrollY > 50) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }
        });
    }

    // Hamburger toggle
    if (hamburger) {
        hamburger.addEventListener('click', function () {
            navLinks && navLinks.classList.toggle('open');
            const spans = hamburger.querySelectorAll('span');
            spans[0].style.transform = navLinks.classList.contains('open') ? 'rotate(45deg) translate(5px, 5px)' : '';
            spans[1].style.opacity = navLinks.classList.contains('open') ? '0' : '1';
            spans[2].style.transform = navLinks.classList.contains('open') ? 'rotate(-45deg) translate(5px, -5px)' : '';
        });
    }

    // Active nav link
    const currentPath = window.location.pathname;
    document.querySelectorAll('.nav-links a').forEach(link => {
        if (link.getAttribute('href') && currentPath.includes(link.getAttribute('href').replace('.jsp', ''))) {
            link.classList.add('active');
        }
    });

    // Animate on scroll
    initScrollAnimations();

    // Close dropdown on outside click
    document.addEventListener('click', function (e) {
        if (!e.target.closest('.nav-dropdown')) {
            document.querySelectorAll('.dropdown-menu').forEach(m => {
                m.style.display = '';
            });
        }
    });
});

// === SCROLL ANIMATIONS ===
function initScrollAnimations() {
    const observer = new IntersectionObserver(function (entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
                observer.unobserve(entry.target);
            }
        });
    }, { threshold: 0.1 });

    document.querySelectorAll('.animate-up, .animate-fade').forEach(el => {
        if (!el.style.opacity) {
            el.style.opacity = '0';
            if (el.classList.contains('animate-up')) {
                el.style.transform = 'translateY(20px)';
            }
            el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        }
        observer.observe(el);
    });
}

// === FORM VALIDATION ===
function validateForm(formId) {
    const form = document.getElementById(formId);
    if (!form) return true;

    let valid = true;
    form.querySelectorAll('[required]').forEach(field => {
        if (!field.value.trim()) {
            showFieldError(field, 'This field is required.');
            valid = false;
        } else {
            clearFieldError(field);
        }
    });

    // Email fields
    form.querySelectorAll('input[type="email"]').forEach(field => {
        if (field.value && !isValidEmail(field.value)) {
            showFieldError(field, 'Please enter a valid email address.');
            valid = false;
        }
    });

    // Password confirm
    const pw = form.querySelector('#password');
    const cpw = form.querySelector('#confirmPassword');
    if (pw && cpw && pw.value !== cpw.value) {
        showFieldError(cpw, 'Passwords do not match.');
        valid = false;
    }

    return valid;
}

function isValidEmail(email) {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

function showFieldError(field, msg) {
    clearFieldError(field);
    field.style.borderColor = '#e74c3c';
    const err = document.createElement('div');
    err.className = 'form-error field-error';
    err.textContent = msg;
    field.parentNode.appendChild(err);
}

function clearFieldError(field) {
    field.style.borderColor = '';
    const existing = field.parentNode.querySelector('.field-error');
    if (existing) existing.remove();
}

// === CHESS CHALLENGE: Prevent duplicate submissions ===
let challengeSubmitted = false;

function submitChallenge(formId) {
    if (challengeSubmitted) {
        alert('You have already submitted this challenge. Refresh the page to try again.');
        return false;
    }
    if (!validateForm(formId)) return false;
    challengeSubmitted = true;
    document.getElementById(formId).submit();
    return true;
}

// === COUNTER ANIMATION for stats ===
function animateCounter(el, target, duration) {
    let start = 0;
    const step = target / (duration / 16);
    const timer = setInterval(function () {
        start += step;
        if (start >= target) {
            el.textContent = target;
            clearInterval(timer);
        } else {
            el.textContent = Math.floor(start);
        }
    }, 16);
}

// === CHESS.COM PUBLIC API ===
async function searchChessComProfile() {
    const username = document.getElementById('chesscomUsername').value.trim();
    const resultDiv = document.getElementById('chesscomResult');
    const loadingDiv = document.getElementById('chesscomLoading');

    if (!username) {
        resultDiv.innerHTML = '<div class="alert alert-error">Please enter a Chess.com username.</div>';
        return;
    }

    resultDiv.innerHTML = '';
    loadingDiv.style.display = 'block';

    try {
        const response = await fetch(`https://api.chess.com/pub/player/${encodeURIComponent(username.toLowerCase())}`);
        loadingDiv.style.display = 'none';

        if (!response.ok) {
            resultDiv.innerHTML = '<div class="alert alert-error">Username not found on Chess.com. Please check the spelling.</div>';
            return;
        }

        const data = await response.json();

        // Fetch stats too
        let statsHtml = '';
        try {
            const statsRes = await fetch(`https://api.chess.com/pub/player/${username.toLowerCase()}/stats`);
            if (statsRes.ok) {
                const stats = await statsRes.json();
                statsHtml = buildStatsHtml(stats);
            }
        } catch (e) { /* stats unavailable */ }

        resultDiv.innerHTML = buildProfileHtml(data, statsHtml);

    } catch (err) {
        loadingDiv.style.display = 'none';
        resultDiv.innerHTML = '<div class="alert alert-error">Unable to reach Chess.com API. Please check your internet connection.</div>';
    }
}

function buildProfileHtml(data, statsHtml) {
    const avatar = data.avatar || 'images/CHESS%20LOGO.png';
    const name = data.name || data.username;
    const title = data.title ? `<span class="badge badge-gold">${data.title}</span>` : '';
    const country = data.country ? data.country.split('/').pop() : 'Unknown';
    const joined = data.joined ? new Date(data.joined * 1000).getFullYear() : 'Unknown';
    const lastOnline = data.last_online ? new Date(data.last_online * 1000).toLocaleDateString() : 'Unknown';
    const status = data.status || 'member';
    const url = data.url || '#';

    return `
    <div class="chesscom-profile">
        <div class="profile-header">
            <img src="${avatar}" alt="${data.username}" class="profile-avatar" onerror="this.src='images/CHESS%20LOGO.png'">
            <div class="profile-info">
                <h3>${name} ${title}</h3>
                <p class="username">@${data.username}</p>
                <div class="profile-meta">
                    <span>🌍 ${country}</span>
                    <span>📅 Member since ${joined}</span>
                    <span>🟢 Last online: ${lastOnline}</span>
                </div>
                <a href="${url}" target="_blank" rel="noopener noreferrer" class="btn btn-sm btn-primary mt-2">
                    View on Chess.com ↗
                </a>
            </div>
        </div>
        ${statsHtml}
        <div class="alert alert-info mt-3" style="font-size:0.8rem;">
            ♟ This profile is displayed using the public Chess.com API. 
            The Last Pawn Chess Academy is an independent platform and is not affiliated with or endorsed by Chess.com.
        </div>
    </div>`;
}

function buildStatsHtml(stats) {
    const ratings = [];
    if (stats.chess_rapid) ratings.push({ type: 'Rapid', rating: stats.chess_rapid.last?.rating, best: stats.chess_rapid.best?.rating });
    if (stats.chess_blitz) ratings.push({ type: 'Blitz', rating: stats.chess_blitz.last?.rating, best: stats.chess_blitz.best?.rating });
    if (stats.chess_bullet) ratings.push({ type: 'Bullet', rating: stats.chess_bullet.last?.rating, best: stats.chess_bullet.best?.rating });
    if (stats.chess_daily) ratings.push({ type: 'Daily', rating: stats.chess_daily.last?.rating, best: stats.chess_daily.best?.rating });
    if (stats.tactics) ratings.push({ type: 'Tactics', rating: stats.tactics.highest?.rating, best: stats.tactics.highest?.rating });

    if (!ratings.length) return '';

    const cards = ratings.map(r => `
        <div class="stat-card">
            <div class="stat-label">${r.type}</div>
            <div class="stat-number">${r.rating || '—'}</div>
            <div style="font-size:0.72rem;color:var(--grey)">Best: ${r.best || '—'}</div>
        </div>`).join('');

    return `<div class="stat-grid mt-3">${cards}</div>`;
}

// === SMOOTH SCROLL for anchor links ===
document.addEventListener('click', function (e) {
    const anchor = e.target.closest('a[href^="#"]');
    if (anchor) {
        const target = document.querySelector(anchor.getAttribute('href'));
        if (target) {
            e.preventDefault();
            target.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    }
});

// === ALERT AUTO-DISMISS ===
document.addEventListener('DOMContentLoaded', function () {
    setTimeout(function () {
        document.querySelectorAll('.alert-success, .alert-error').forEach(function (el) {
            el.style.transition = 'opacity 0.5s ease';
            el.style.opacity = '0';
            setTimeout(() => el.remove(), 500);
        });
    }, 5000);
});
