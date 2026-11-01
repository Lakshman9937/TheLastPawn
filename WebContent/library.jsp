<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.lastpawn.db.DBConnection" %>
<%
    request.setAttribute("currentPage", "library");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chess Library & Knowledge Base — The Last Pawn Chess Academy</title>
    <link rel="icon" type="image/png" href="images/CHESS%20LOGO.png">
    <link rel="stylesheet" href="css/style.css">
    <style>
        /* ── IMAGE MAP STAGE ── */
        .imagemap-section {
            background: #181614;
            padding: 3rem 1rem;
            border-bottom: 2px solid var(--gold);
            text-align: center;
        }
        .imagemap-wrapper {
            display: inline-block;
            position: relative;
            max-width: 100%;
            border: 4px solid var(--gold);
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 15px 50px rgba(0,0,0,0.5);
        }
        .imagemap-wrapper img {
            display: block;
            max-width: 100%;
            height: auto;
            cursor: pointer;
        }
        map area {
            cursor: pointer;
        }
        .map-hint {
            color: var(--gold);
            font-size: 0.95rem;
            font-weight: 700;
            margin-top: 1rem;
            letter-spacing: 1px;
        }
        .piece-selector-pills {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 1.5rem;
        }
        .piece-pill {
            background: rgba(38,36,33,0.85);
            border: 1.5px solid rgba(214,163,74,0.4);
            color: #FFFFFF;
            padding: 8px 18px;
            border-radius: 24px;
            font-size: 0.95rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.25s ease;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .piece-pill:hover, .piece-pill.active {
            background: var(--gold);
            color: var(--charcoal);
            border-color: var(--gold);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(214,163,74,0.4);
        }

        /* ── PIECE CARDS ── */
        .piece-details-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(340px, 1fr));
            gap: 2rem;
            margin-top: 2.5rem;
        }
        .piece-card {
            background: #FFFFFF;
            border-radius: 16px;
            padding: 2rem;
            border: 2px solid rgba(214,163,74,0.25);
            box-shadow: 0 8px 30px rgba(0,0,0,0.06);
            transition: all 0.3s ease;
            position: relative;
        }
        .piece-card:hover, .piece-card.highlighted {
            transform: translateY(-6px);
            border-color: var(--gold) !important;
            box-shadow: 0 16px 45px rgba(214,163,74,0.3) !important;
            background: linear-gradient(180deg, #FFFFFF, #fffdf7) !important;
        }
        .piece-header {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 1.2rem;
            border-bottom: 1px solid rgba(0,0,0,0.08);
            padding-bottom: 1rem;
        }
        .piece-icon-box {
            width: 58px;
            height: 58px;
            border-radius: 12px;
            background: #262421;
            color: var(--gold);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.3rem;
            border: 2px solid var(--gold);
            flex-shrink: 0;
        }
        .piece-thumb {
            width: 58px;
            height: 58px;
            border-radius: 12px;
            object-fit: cover;
            border: 2px solid var(--gold);
            flex-shrink: 0;
        }
        .rule-box {
            background: #f7f7f5;
            padding: 0.85rem 1.1rem;
            border-radius: 10px;
            font-size: 0.88rem;
            color: var(--charcoal);
            margin-top: 0.8rem;
            border-left: 3px solid var(--gold);
        }

        /* ── RESOURCE SECTIONS ── */
        .resource-category {
            background: #FFFFFF;
            border-radius: 16px;
            padding: 2.5rem;
            border: 1px solid rgba(214,163,74,0.2);
            box-shadow: 0 6px 25px rgba(0,0,0,0.05);
            margin-bottom: 2.5rem;
        }
        .resource-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.5rem;
            margin-top: 1.5rem;
        }
        .res-item {
            background: #fdfcf9;
            border: 1px solid rgba(0,0,0,0.08);
            border-radius: 12px;
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
    </style>
</head>
<body>

<%@ include file="navbar.jsp" %>

<!-- Header Banner -->
<header class="page-header" style="background: linear-gradient(135deg, #1b1917, #262421); padding: 70px 20px; text-align: center; border-bottom: 3px solid var(--gold);">
    <div class="container">
        <span class="section-tag">Grandmaster Archives</span>
        <h1 style="font-size: 3rem; font-weight: 900; color: #FFFFFF; margin: 0.5rem 0;">CHESS <span style="color:var(--gold);">LIBRARY</span></h1>
        <p style="color: var(--off-white); max-width: 650px; margin: 0.8rem auto 0; font-size: 1.05rem;">
            Explore interactive piece dynamics, tactical motifs, opening compendiums, endgame blueprints, and downloadable study guides.
        </p>
    </div>
</header>

<!-- ============ INTERACTIVE CHESS IMAGE MAP ============ -->
<section class="imagemap-section">
    <div class="container">
        <span class="section-tag" style="margin-bottom:0.8rem;">Interactive Board Explorer</span>
        <h2 style="font-size:2.2rem;font-weight:900;color:#FFFFFF;margin-bottom:0.5rem;">The Crystal Chess <span style="color:var(--gold);">Piece Map</span></h2>
        <p style="color:var(--off-white);max-width:700px;margin:0 auto 1.5rem;font-size:0.95rem;">
            Click any crystal chess piece directly on the board below to inspect its movement dynamics, tactical role, and strategic value.
        </p>

        <div class="imagemap-wrapper">
            <img src="images/Chesscrystal.jpg" usemap="#chessmap" id="crystalBoard" width="1402" height="1122" alt="Crystal Chess Pieces Map">
            <map name="chessmap" id="chessmap">
                <!-- 1. Left Pawn (x: 10 - 115) -->
                <area shape="rect" coords="10,180,115,500" href="#pawn" onclick="selectPiece('pawn'); return false;" alt="Pawn" title="The Pawn — Soul of Chess">
                <!-- 2. Left Rook (x: 115 - 195) -->
                <area shape="rect" coords="115,140,195,500" href="#rook" onclick="selectPiece('rook'); return false;" alt="Rook" title="The Rook — Open Files Heavy Artillery">
                <!-- 3. Left Knight (x: 195 - 330) -->
                <area shape="rect" coords="195,160,330,580" href="#knight" onclick="selectPiece('knight'); return false;" alt="Knight" title="The Knight — Tactical Fork Specialist">
                <!-- 4. Left Bishop (x: 330 - 460) -->
                <area shape="rect" coords="330,180,460,690" href="#bishop" onclick="selectPiece('bishop'); return false;" alt="Bishop" title="The Bishop — Diagonal Sniper">
                <!-- 5. Left Queen (x: 460 - 610) -->
                <area shape="rect" coords="460,210,610,830" href="#queen" onclick="selectPiece('queen'); return false;" alt="Queen" title="The Queen — Supreme Attacker & Defender">
                <!-- 6. King (x: 610 - 790) -->
                <area shape="rect" coords="610,230,790,960" href="#king" onclick="selectPiece('king'); return false;" alt="King" title="The King — Sovereign Leader">
                <!-- 7. Right Queen (x: 790 - 940) -->
                <area shape="rect" coords="790,210,940,830" href="#queen" onclick="selectPiece('queen'); return false;" alt="Queen" title="The Queen — Supreme Attacker & Defender">
                <!-- 8. Right Bishop (x: 940 - 1070) -->
                <area shape="rect" coords="940,180,1070,690" href="#bishop" onclick="selectPiece('bishop'); return false;" alt="Bishop" title="The Bishop — Diagonal Sniper">
                <!-- 9. Right Knight (x: 1070 - 1200) -->
                <area shape="rect" coords="1070,160,1200,580" href="#knight" onclick="selectPiece('knight'); return false;" alt="Knight" title="The Knight — Tactical Fork Specialist">
                <!-- 10. Right Rook (x: 1200 - 1285) -->
                <area shape="rect" coords="1200,140,1285,500" href="#rook" onclick="selectPiece('rook'); return false;" alt="Rook" title="The Rook — Open Files Heavy Artillery">
                <!-- 11. Right Pawn (x: 1285 - 1395) -->
                <area shape="rect" coords="1285,180,1395,500" href="#pawn" onclick="selectPiece('pawn'); return false;" alt="Pawn" title="The Pawn — Soul of Chess">
            </map>
        </div>
        <p class="map-hint">♟ Click any crystal piece on the board or use the quick-selectors below:</p>

        <!-- Interactive Quick Selectors -->
        <div class="piece-selector-pills">
            <button type="button" class="piece-pill" id="pill-pawn" onclick="selectPiece('pawn')">♟ The Pawn</button>
            <button type="button" class="piece-pill" id="pill-rook" onclick="selectPiece('rook')">♜ The Rook</button>
            <button type="button" class="piece-pill" id="pill-knight" onclick="selectPiece('knight')">♞ The Knight</button>
            <button type="button" class="piece-pill" id="pill-bishop" onclick="selectPiece('bishop')">♝ The Bishop</button>
            <button type="button" class="piece-pill" id="pill-queen" onclick="selectPiece('queen')">♛ The Queen</button>
            <button type="button" class="piece-pill" id="pill-king" onclick="selectPiece('king')">♚ The King</button>
        </div>
    </div>
</section>

<!-- ============ PIECE DIRECTORY ============ -->
<section class="section section-light">
    <div class="container">
        <div class="section-header">
            <span class="section-tag">Piece Masterclasses</span>
            <h2>The Six <span>Chess Elements</span></h2>
            <div class="gold-line"></div>
        </div>

        <div class="piece-details-grid">
            <!-- 1. PAWN -->
            <div class="piece-card" id="card-pawn">
                <div class="piece-header">
                    <img src="images/crops/crop_1.jpg" alt="The Pawn" class="piece-thumb" onerror="this.style.display='none'">
                    <div class="piece-icon-box">♟</div>
                    <div>
                        <h3 style="font-size:1.35rem;font-weight:800;color:var(--charcoal);margin:0;">The Pawn</h3>
                        <span class="badge badge-warning" style="margin-top:4px;">Value: 1 Point · Logo Piece</span>
                    </div>
                </div>
                <p style="color:var(--grey);font-size:0.92rem;line-height:1.7;">
                    The foot soldier of chess and the foundation of all strategy. Pawns create territory boundaries, shield your king, and march toward transformation.
                </p>
                <div class="rule-box">
                    <strong>Movement Rules:</strong> Moves 1 square forward (or optionally 2 squares on its very first move). Captures 1 square diagonally forward. Possesses two special powers: <em>En Passant</em> capture and <strong>Promotion</strong> upon reaching the 8th rank.
                </div>
                <div class="rule-box" style="border-left-color: var(--sage);">
                    <strong>Strategic Value:</strong> Pawn structures dictate the entire game plan, establish central outposts, and decide winning pawn endgames.
                </div>
            </div>

            <!-- 2. ROOK -->
            <div class="piece-card" id="card-rook">
                <div class="piece-header">
                    <img src="images/crops/crop_2.jpg" alt="The Rook" class="piece-thumb" onerror="this.style.display='none'">
                    <div class="piece-icon-box">♜</div>
                    <div>
                        <h3 style="font-size:1.35rem;font-weight:800;color:var(--charcoal);margin:0;">The Rook</h3>
                        <span class="badge badge-primary" style="margin-top:4px;">Value: 5 Points (Major Piece)</span>
                    </div>
                </div>
                <p style="color:var(--grey);font-size:0.92rem;line-height:1.7;">
                    The castle tower and heavy artillery of the chessboard. Rooks dominate straight lines across the entire board with limitless range.
                </p>
                <div class="rule-box">
                    <strong>Movement Rules:</strong> Moves any number of unoccupied squares horizontally along ranks or vertically along files. Participates in <em>Castling</em> with the King for king protection and rook activation.
                </div>
                <div class="rule-box" style="border-left-color: var(--sage);">
                    <strong>Strategic Value:</strong> Rooks belong on open files and the 7th rank where they devastate the opponent's pawns and trap the defending king.
                </div>
            </div>

            <!-- 3. KNIGHT -->
            <div class="piece-card" id="card-knight">
                <div class="piece-header">
                    <img src="images/crops/crop_3.jpg" alt="The Knight" class="piece-thumb" onerror="this.style.display='none'">
                    <div class="piece-icon-box">♞</div>
                    <div>
                        <h3 style="font-size:1.35rem;font-weight:800;color:var(--charcoal);margin:0;">The Knight</h3>
                        <span class="badge badge-info" style="margin-top:4px;">Value: 3 Points (Minor Piece)</span>
                    </div>
                </div>
                <p style="color:var(--grey);font-size:0.92rem;line-height:1.7;">
                    The trickiest and most deceptive fighter in chess. The Knight moves in unexpected angles, making it a master of stealth and tactical surprise.
                </p>
                <div class="rule-box">
                    <strong>Movement Rules:</strong> Moves in an "L-shape" (2 squares in one cardinal direction, then 1 square perpendicular). <strong>It is the only chess piece capable of leaping over friendly and enemy pieces.</strong>
                </div>
                <div class="rule-box" style="border-left-color: var(--sage);">
                    <strong>Strategic Value:</strong> Deadly in closed and locked pawn formations; legendary for devastating multi-piece forks attacking king and queen simultaneously.
                </div>
            </div>

            <!-- 4. BISHOP -->
            <div class="piece-card" id="card-bishop">
                <div class="piece-header">
                    <img src="images/crops/crop_4.jpg" alt="The Bishop" class="piece-thumb" onerror="this.style.display='none'">
                    <div class="piece-icon-box">♝</div>
                    <div>
                        <h3 style="font-size:1.35rem;font-weight:800;color:var(--charcoal);margin:0;">The Bishop</h3>
                        <span class="badge badge-info" style="margin-top:4px;">Value: 3 Points (Minor Piece)</span>
                    </div>
                </div>
                <p style="color:var(--grey);font-size:0.92rem;line-height:1.7;">
                    The long-range sniper of chess. Glides silently across open diagonals, pinning enemy pieces and launching long-distance surprise attacks.
                </p>
                <div class="rule-box">
                    <strong>Movement Rules:</strong> Moves any distance diagonally across unoccupied squares of its own designated color. Each player commands one light-squared bishop and one dark-squared bishop.
                </div>
                <div class="rule-box" style="border-left-color: var(--sage);">
                    <strong>Strategic Value:</strong> The <em>bishop pair</em> dominates wide-open positions by slicing through enemy defenses across complementary colored diagonals.
                </div>
            </div>

            <!-- 5. QUEEN -->
            <div class="piece-card" id="card-queen">
                <div class="piece-header">
                    <img src="images/crops/crop_5.jpg" alt="The Queen" class="piece-thumb" onerror="this.style.display='none'">
                    <div class="piece-icon-box">♛</div>
                    <div>
                        <h3 style="font-size:1.35rem;font-weight:800;color:var(--charcoal);margin:0;">The Queen</h3>
                        <span class="badge badge-success" style="margin-top:4px;">Value: 9 Points (Major Piece)</span>
                    </div>
                </div>
                <p style="color:var(--grey);font-size:0.92rem;line-height:1.7;">
                    The supreme commander and most powerful attacking engine on the chessboard. Capable of turning any battle into an immediate decisive victory.
                </p>
                <div class="rule-box">
                    <strong>Movement Rules:</strong> Combines the full powers of both the Rook and Bishop. Moves any number of squares horizontally, vertically, or diagonally across clear paths.
                </div>
                <div class="rule-box" style="border-left-color: var(--sage);">
                    <strong>Strategic Value:</strong> Lethal checkmating force and multi-target fork monster. Protect your queen and avoid developing it prematurely to avoid harassment.
                </div>
            </div>

            <!-- 6. KING -->
            <div class="piece-card" id="card-king">
                <div class="piece-header">
                    <img src="images/crops/crop_6.jpg" alt="The King" class="piece-thumb" onerror="this.style.display='none'">
                    <div class="piece-icon-box">♚</div>
                    <div>
                        <h3 style="font-size:1.35rem;font-weight:800;color:var(--charcoal);margin:0;">The King</h3>
                        <span class="badge badge-danger" style="margin-top:4px;">Invaluable · The Entire Game</span>
                    </div>
                </div>
                <p style="color:var(--grey);font-size:0.92rem;line-height:1.7;">
                    The heart and sovereign of the game. If your king is trapped without escape, the battle is immediately lost regardless of remaining material.
                </p>
                <div class="rule-box">
                    <strong>Movement Rules:</strong> Moves 1 square in any direction (horizontally, vertically, or diagonally). A King can never move into check or remain under attack. Participates in <em>Castling</em>.
                </div>
                <div class="rule-box" style="border-left-color: var(--sage);">
                    <strong>Strategic Value:</strong> Must be kept safely sheltered behind pawn shields during opening/middlegame; transforms into a decisive attacking general in endgames.
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ============ CURATED LEARNING RESOURCES ============ -->
<section class="section section-dark">
    <div class="container">
        <div class="section-header light">
            <span class="section-tag">Knowledge Vault</span>
            <h2>Study Guides, <span>Tactics & Principles</span></h2>
            <div class="gold-line"></div>
            <p>Downloadable references, opening systems, and fundamental guidelines</p>
        </div>

        <div class="resource-category" style="background:#262421;color:#FFFFFF;border-color:rgba(214,163,74,0.3);">
            <h3 style="font-size:1.5rem;font-weight:800;color:var(--gold);margin-bottom:1.5rem;display:flex;align-items:center;gap:10px;">
                <span>📚</span> Downloadable Study Materials (PDF & PGN)
            </h3>
            <div class="resource-grid">
                <div class="res-item" style="background:#1b1917;border-color:rgba(214,163,74,0.2);">
                    <div>
                        <span style="font-size:0.75rem;font-weight:700;color:var(--sage);text-transform:uppercase;">PDF Guide</span>
                        <h4 style="color:#FFF;margin:0.5rem 0 0.8rem;">FIDE Official Laws of Chess 2026</h4>
                        <p style="color:var(--grey);font-size:0.85rem;line-height:1.6;">Full official rulebook covering illegal moves, clocks, tournament conduct, and draw scenarios.</p>
                    </div>
                    <a href="uploads/materials/fide-rules.pdf" download class="btn btn-sm btn-secondary mt-3">Download PDF ⤓</a>
                </div>
                <div class="res-item" style="background:#1b1917;border-color:rgba(214,163,74,0.2);">
                    <div>
                        <span style="font-size:0.75rem;font-weight:700;color:var(--gold);text-transform:uppercase;">Opening Compendium</span>
                        <h4 style="color:#FFF;margin:0.5rem 0 0.8rem;">Top 10 Essential Chess Openings</h4>
                        <p style="color:var(--grey);font-size:0.85rem;line-height:1.6;">Italian Game, Sicilian Defense, Queen's Gambit, French Defense, and King's Indian systems.</p>
                    </div>
                    <a href="uploads/materials/essential-openings.pdf" download class="btn btn-sm btn-secondary mt-3">Download PDF ⤓</a>
                </div>
                <div class="res-item" style="background:#1b1917;border-color:rgba(214,163,74,0.2);">
                    <div>
                        <span style="font-size:0.75rem;font-weight:700;color:var(--sage);text-transform:uppercase;">Endgame Reference</span>
                        <h4 style="color:#FFF;margin:0.5rem 0 0.8rem;">100 Endgames You Must Know</h4>
                        <p style="color:var(--grey);font-size:0.85rem;line-height:1.6;">Key opposition positions, Philidor defense, Lucena bridge building, and square of the pawn.</p>
                    </div>
                    <a href="uploads/materials/100-endgames.pdf" download class="btn btn-sm btn-secondary mt-3">Download PDF ⤓</a>
                </div>
            </div>
        </div>

        <div class="resource-category" style="background:#262421;color:#FFFFFF;border-color:rgba(214,163,74,0.3);">
            <h3 style="font-size:1.5rem;font-weight:800;color:var(--gold);margin-bottom:1.5rem;display:flex;align-items:center;gap:10px;">
                <span>🎬</span> Video Tutorials & Masterclasses
            </h3>
            <div class="resource-grid">
                <div class="res-item" style="background:#1b1917;border-color:rgba(214,163,74,0.2);">
                    <div>
                        <span style="font-size:0.75rem;font-weight:700;color:var(--gold);text-transform:uppercase;">Video Lecture</span>
                        <h4 style="color:#FFF;margin:0.5rem 0 0.8rem;">Pawn Structures: Isolated vs Doubled</h4>
                        <p style="color:var(--grey);font-size:0.85rem;line-height:1.6;">How pawn skeletons determine strategic play and the transition into winning pawn endgames.</p>
                    </div>
                    <a href="https://www.youtube.com/results?search_query=chess+pawn+structures+masterclass" target="_blank" rel="noopener" class="btn btn-sm btn-primary mt-3">Watch Lecture ↗</a>
                </div>
                <div class="res-item" style="background:#1b1917;border-color:rgba(214,163,74,0.2);">
                    <div>
                        <span style="font-size:0.75rem;font-weight:700;color:var(--gold);text-transform:uppercase;">Video Lecture</span>
                        <h4 style="color:#FFF;margin:0.5rem 0 0.8rem;">Mastering the Tactical Fork</h4>
                        <p style="color:var(--grey);font-size:0.85rem;line-height:1.6;">Spotting Knight, Pawn, and Queen forks before your opponent can escape the pin or threat.</p>
                    </div>
                    <a href="https://www.youtube.com/results?search_query=chess+tactical+forks+tutorial" target="_blank" rel="noopener" class="btn btn-sm btn-primary mt-3">Watch Lecture ↗</a>
                </div>
                <div class="res-item" style="background:#1b1917;border-color:rgba(214,163,74,0.2);">
                    <div>
                        <span style="font-size:0.75rem;font-weight:700;color:var(--gold);text-transform:uppercase;">Video Lecture</span>
                        <h4 style="color:#FFF;margin:0.5rem 0 0.8rem;">The Lucena Endgame Formula</h4>
                        <p style="color:var(--grey);font-size:0.85rem;line-height:1.6;">Step-by-step technique to build a bridge and promote your pawn in Rook + Pawn vs Rook endings.</p>
                    </div>
                    <a href="https://www.youtube.com/results?search_query=chess+lucena+position+tutorial" target="_blank" rel="noopener" class="btn btn-sm btn-primary mt-3">Watch Lecture ↗</a>
                </div>
            </div>
        </div>
    </div>
</section>

<%@ include file="footer.jsp" %>

<script>
    // Responsive image map coordinate scaler
    function resizeChessMap() {
        const img = document.getElementById('crystalBoard');
        if (!img) return;
        const origW = 1402;
        const origH = 1122;
        const currentW = img.clientWidth;
        const currentH = img.clientHeight;
        if (currentW === 0 || currentH === 0) return;

        const scaleX = currentW / origW;
        const scaleY = currentH / origH;

        const areas = document.querySelectorAll('#chessmap area');
        areas.forEach(function(area) {
            if (!area.getAttribute('data-base-coords')) {
                area.setAttribute('data-base-coords', area.getAttribute('coords'));
            }
            const baseCoords = area.getAttribute('data-base-coords').split(',').map(Number);
            const scaled = baseCoords.map((c, i) => Math.round(i % 2 === 0 ? c * scaleX : c * scaleY));
            area.setAttribute('coords', scaled.join(','));
        });
    }

    // Direct click fallback listener on the image
    const crystalImg = document.getElementById('crystalBoard');
    if (crystalImg) {
        crystalImg.addEventListener('click', function(e) {
            const rect = this.getBoundingClientRect();
            const clickX = e.clientX - rect.left;
            const scale = this.clientWidth / 1402;
            const origX = clickX / scale;

            let piece = '';
            if (origX < 115) piece = 'pawn';
            else if (origX < 195) piece = 'rook';
            else if (origX < 330) piece = 'knight';
            else if (origX < 460) piece = 'bishop';
            else if (origX < 610) piece = 'queen';
            else if (origX < 790) piece = 'king';
            else if (origX < 940) piece = 'queen';
            else if (origX < 1070) piece = 'bishop';
            else if (origX < 1200) piece = 'knight';
            else if (origX < 1285) piece = 'rook';
            else piece = 'pawn';

            selectPiece(piece);
        });

        if (crystalImg.complete) {
            resizeChessMap();
        } else {
            crystalImg.addEventListener('load', resizeChessMap);
        }
    }

    window.addEventListener('load', resizeChessMap);
    window.addEventListener('resize', resizeChessMap);

    function selectPiece(pieceName) {
        // Deselect all
        document.querySelectorAll('.piece-card').forEach(c => c.classList.remove('highlighted'));
        document.querySelectorAll('.piece-pill').forEach(p => p.classList.remove('active'));

        const target = document.getElementById('card-' + pieceName);
        const pill = document.getElementById('pill-' + pieceName);

        if (pill) pill.classList.add('active');
        if (target) {
            target.classList.add('highlighted');
            target.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
    }
</script>
<script src="js/main.js"></script>
</body>
</html>