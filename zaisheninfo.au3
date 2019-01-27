#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon_zaisheninfo.ico
#AutoIt3Wrapper_Res_Language=1031
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Array.au3>
#include <MsgBoxConstants.au3>
#include <StringConstants.au3>
#include <IE.au3>
#include <string.au3>
#include <File.au3>
#include <INet.au3>
#include "Toast.au3" ; thanks to Melba23 from autoitscript.com

global $language = 1 ; 1=German,2=English,3=French
global $file= @scriptdir&"\vanq.jpg"
global $p_mission= @scriptdir&"\mission.jpg"
global $var =InetRead("https://www.guildwiki.de/wiki/Liste_der_t%C3%A4glichen_Auftr%C3%A4ge",8) ; list of all daily quests
global $original=BinaryToString($var)



;fixed loop thanks to Ralle1976
;~ _GetOSLanguage() ; set language thanks to guiness from autoitscript.com

Func _GetOSLanguage()
    Local Const $sID = StringRight(@OSLang, StringLen('09'))
    Return StringRegExp('|06Chinese|' & _
            '06Danish|13Dutch|' & _
            '25Estonian|' & _
            '0bFinnish|0cFrench|' & _
            '07German|08Greek|' & _
            '0eHungarian|' & _
            '10Italian|' & _
            '11Japanese|' & _
            '14Norwegian|' & _
            '15Polish|16Portuguese|' & _
            '18Romanian|19Russian|' & _
            '1aSerbian|0aSpanish|1dSwedish|' & _
            $sID & 'English|', _
            '\|' & $sID & '([^|]+)\|', $STR_REGEXPARRAYGLOBALMATCH)[0]
EndFunc   ;==>_GetOSLanguage


if _GetOSLanguage() ="Francais" then
	$language=3
	msgbox(0,"Translation","Your language is not completely implemented yet, so you might get empty responses." & @crlf &"If you would like to help translating -> contact me")
elseif _GetOSLanguage() ="German" then
	$language= 1
elseif _GetOSLanguage() ="English" then
	$language=2
endif





#Region Mission-Array definition
; need special characters here to download images correctly
local $Missionen = [['Der Gro%C3%9Fe Nordwall','Der Große Nordwall','The Great Northern Wall'] _
,['Fort_Ranik','Fort Ranik','Fort Ranik'] _
,['Tore_von_Kryta','Tore von Kryta','Gates of Kryta'] _
,['Ruinen_von_Surmia','Ruinen von Surmia','Ruins of Surmia'] _
,['Nolani-Akademie','Nolani-Akademie','Nolani-Academy'] _
,['Borlispass','Borlispass','Borlis Pass'] _
,['Das_Frosttor','Das Frosttor','The Frost Gate'] _
,["D'Alessio-KÃ¼ste","D'Alessio-Küste","D`Alessio Seaboard"] _
,['KÃ¼ste_der_GÃ¶ttlichkeit','Küste der Göttlichkeit','Divinity Coast'] _
,['Die_Wildnis','Die Wildnis','The Wilds'] _
,['Blutsteinsumpf','Blutsteinsumpf','Bloodstone Fen'] _
,['Auroralichtung','Auroralichtung','Aurora Glade'] _
,['Flussuferprovinz','Flussuferprovinz','Riverside Province'] _
,['Riff_der_Stille','Riff der Stille','Sanctum Cay'] _
,['D%C3%BCnen_der_Verzweiflung','Dünen der Verzweiflung','Dunes of Despair'] _
,['Durstiger_Fluss','Durstiger Fluss', 'Thirsty River'] _
,['Elonaspitze','Elonaspitze','Elona Reach'] _
,['Fels_der_Weissagung','Fels der Weissagung','Augury Rock'] _
,['Die_DrachenhÃ¶hle','Die Drachenhöhle','The Dragons Lair'] _
,['EishÃ¶hlen_der_BetrÃ¼bnis','Eishöhlen der Betrübnis','Ice Caves Of Sorrow'] _
,['Eisenminen_von_Moladune','Eisenminen von Moladune', 'Iron Mines of Moladune'] _
,['Feste_Donnerkopf','Feste Donnerkopf','Thunderhead Keep'] _
,['Feuerring','Feuerring','Ring Of Fire'] _
,['Abbadons_Maul','Abbadons Maul','Abaddon´s Mouth'] _
,['Vorhof_der_H%C3%B6lle',' Vorhof der Hölle','Hell´s Precipice'] _
,['Minister_Chos_Anwesen','Minister Chos Anwesen','Minister Cho´s Estate'] _
,['Zen_Daijun','Zen Daijun','Zen Daijun'] _
,['Vizunahplatz','Vizunahplatz','Vizunah Square'] _
,['Nahpuiviertel','Nahpuiviertel','Nahpui Quarter'] _
,['Tahnnakai-Tempel','Tahnnakai-Tempel','Tahnnakai Temple'] _
,['Arborstein','Arborstein','Arborstone'] _
,['Boreas-Meeresgrund','Boreas-Meeresgrund','Boreas Seabed'] _
,['Sunjiang-Bezirk','Sunjiang-Bezirk','Sunjiang District'] _
,['Der_Ewige_Hain','Der Ewige Hain','The Eternal Grove'] _
,['Gyala-BrustÃ¤tte','Gyala-Brustätte','Gyala Hatchery'] _
,['Verschlafene_GewÃ¤sser','Verschlafene Gewässer','Unwaking Waters',"Dunes du Désespoir"] _
,['Raisu-Palast','Raisu-Palast','Raisu Palace'] _
,['Kaiserliches_Refugium','Kaiserliches Refugium','Imperial Sanctum'] _
,['Chahbek','Chahbek','Chahbek VIllage'] _
,['Ausgrabungsst%C3%A4tte_von_Jokanur','Ausgrabungsstätte von Jokanur','Jokanur Diggins'] _
,['Schwarzwasserloch','Schwarzwasserloch','Blacktide Den'] _
,['Konsulatshafen','Konsulatshafen','Consulate Docks'] _
,['Totenanger_von_Venta','Totenanger von Venta','Venta Cemetery'] _
,['Kodonur-Kreuzung','Kodonur-Kreuzung','Kodonur Crossroads'] _
,['Passage_von_Pogahn','Passage von Pogahn','Pogahn Passage'] _
,['Rilohn-Refugium','Rilohn-Refugium','Rihlon Refuge'] _
,['Moddok-Spalte','Moddok-Spalte','Moddok Crevice'] _
,['Obstgarten_von_Tihark','Obstgarten von Tihark','Tihard Orkchard'] _
,['Vorhof_von_Dasha','Vorhof von Dasha','Dasha Vestibule'] _
,['Bastion_von_Dzagonur','Bastion von Dzagonur','Dzagonur Bastion'] _
,['Gro%C3%9Fer_Hof_von_Sebelkeh','Großer Hof von Selbelkeh','Grand Court of Selbelkeh'] _
,['Jennurs_Horde','Jennurs Horde','Jennur´s Horde'] _
,['Nundu-Bucht','Nundu-Bucht','Nundu Bay'] _
,['Ã–dland-Tor','Ödland-Tor','Gate Of Desolation'] _
,['Ruinen_von_Morah','Ruinen von Morah','Ruins of Morah'] _
,['Tor_des_Schmerzes','Tor des Schmerzes','Gate of Pain'] _
,['Tor_des_Wahnsinns','Tor des Wahnsinns','Gate of Madness'] _
,['Abaddons_Tor','Abaddons Tor','Abaddon´s Gate'] _
,['Der_Fluch_des_NornbÃ¤ren','Fluch des Nornbären','Curse Of The Nornbear'] _
,['Ein_Portal_zu_weit','Ein Portal zu weit','A Gate Too Far'] _
,['Blut_wÃ¤scht_Blut' ,'Blut wäscht Blut','Blood Washes Blood'] _
,['Auf_der_Suche_nach_dem_Blutstein','Auf der Suche nach dem Blutstein','Finding The Bloodstone'] _
,['Die_scheue_Golemantin','Die scheue Golemantin','The Elusive Golemancer'] _
,['G.O.L.E.M.','G.O.L.E.M','Genius Operated Living Enchanted Manifestation'] _
,['Gegen_die_Charr','Gegen die Charr','Against The Charr'] _
,['Brudertrupp','Brudertrupp','Warband Of Brothers'] _
,['Der_Angriff_auf_die_Festung','Der Angriff auf die Festung','Assault On The Stronghold'] _
,['Tiefen_der_Zerst%C3%B6rung','Tiefen der Zerstörung','Destruction´s Depths'] _; Tiefen der Zerstörung
,['Eine_Zeit_fÃ¼r_Helden','Eine Zeit für Helden','A Time For Heroes']] ; Eine Zeit für Helden

;_ArrayDisplay($Missionen)
#EndRegion

#Region Vanq-Array definition
; Bezwingungen
local $Vanq[][4]=[['Alt-Ascalon','Alt-Ascalon','Old Ascalon'] _
,['Ascalon-Vorgebirge','Ascalon-Vorgebirge','Ascalon Foothills'] _
,['Die_Bresche','Die Bresche','The Breach'] _
,['Drachenschlund','Drachenschlund','Dragon''s Gullet'] _
,['Flammentempel-Gang','Flammentempel-Gang','Flame Temple Corridor'] _
,['Ostgrenze','Ostgrenze','Eastern Frontier'] _
,['Pockennarbenebene','Pockennarbenebene','Pockmark Flats'] _
,['Regentental','Regentental','Regent Valley'] _
,['Tiefland_von_Diessa','Tiefland von Diessa','Diessa Lowlands'] _
,['Ambossstein','Ambossstein','Anvil Rock'] _
,['Deldrimor-Becken','Deldrimor-Becken','Deldrimor Bowl'] _
,['Tal_des_Reisenden','Tal des Reisenden','Traveler''s Vale'] _
,['Greifenmaul','Greifenmaul','Griffon''s Mouth'] _
,['Eisenrossmine','Eisenrossmine','Iron Horse Mine'] _
,['Der_Schwarze_Vorhang','Der Schwarze Vorhang','The Black Curtain'] _
,['Kessex-Gipfel','Kessex-Gipfel','Kessex Peak'] _
,['K%C3%B6nigsruh','Königsruh','Majesty''s Rest'] _ ; Königsruh
,['Nebo-Terrasse','Nebo-Terrasse','Nebo Terrace'] _
,['Provinz_Nordkryta','Provinz Nordkryta','North Kryta Province'] _
,['Schurkenh%C3%BCgel','Schurkenhügel','Scoundrel''s Rise'] _
,['Stachelrochenstrand','Stachelrochenstrand','Stingray Strand'] _
,['Talmark-Wildnis','Talmark-Wildnis','Talmark Wilderness'] _
,['Tr%C3%A4nen_der_Gefallenen','Tränen der Gefallenen','Tears of the Fallen',"Valis l'effréné"] _
,['Verfluchtes_Land','Verfluchtes Land','Cursed Lands'] _
,['Wachturmküste','Wachturmküste','Watchtower Coast'] _
,['Zwillingsschlangenseen','Zwillingsschlangenseen','Twin Serpent Lakes'] _
,['Die_Wasserf%C3%A4lle','Die Wasserfälle','The Falls'] _
,['Ettinbuckel','Ettinbuckel','Ettin''s Back'] _
,['Land_der_Weisen','Land der Weisen','Sage Lands'] _
,['Mamnoon-Lagune','Mamnoon-Lagune','Mamnoon Lagoon'] _
,['Schilfmoor','Schilfmoor','Reed Bog'] _
,['Silberholz','Silberholz','Silverwood'] _
,['Trockenkuppe','Trockenkuppe','Dry Top'] _
,['Wildwurzel','Wildwurzel','Tangle Root'] _
,['Das_Trockene_Meer','Das Trockene Meer','The Arid Sea'] _
,['Die_Narbe','Die Narbe','The Scar'] _
,['Geierd%C3%BCnen','Geierdünen','Vulture Drifts'] _
,['Himmelsspitze','Himmelsspitze','Skyward Reach'] _
,['Pfad_des_Propheten','Pfad des Propheten','Prophet''s Path'] _
,['Salzebenen','Salzebenen','Salt Flats'] _
,['Wahrsagerh%c3%b6he','Wahrsagerhöhe','Diviner''s Ascent'] _
,['Pfad_des_Propheten','Pfad des Propheten','Prophet''s Path'] _
,['Eisdom','Eisdom','Icedome'] _
,['Eisscholle','Eisscholle','Ice Floe'] _
,['Frostwald','Frostwald','Frozen Forest'] _
,['Grenths_Fu%C3%9Fabdruck','Grenths Fußabdruck','Grenth''s Footprint'] _
,['Lornarpass','Lornarpass','Lornar''s Pass'] _
,['Mineralquellen','Mineralquellen','Mineral Springs'] _
,['Schlangentanz','Schlangentanz','Snake Dance'] _
,['Schreckensdrift','Schreckensdrift','Dreadnought''s Drift'] _
,['Speerspitzengipfel','Speerspitzengipfel','Spearhead Peak'] _
,['Talusschnelle','Talusschnelle','Talus Chute'] _
,['Tascas_Ableben','Tascas Ableben','Tasca''s Demise'] _
,['Witmans_Torheit','Witmans Torheit','Witman''s Folly'] _
,['Fels_der_Verdammnis','Fels der Verdammnis','Perdition Rock'] _
,['Haiju-Lagune','Haiju-Lagune','Haiju Lagoon'] _
,['Jaya-Klippen','Jaya-Klippen','Jaya Bluffs'] _
,['Minister_Chos_Anwesen','Minister Chos Anwesen','Minister Cho''s Estate'] _
,['Panjiang-Halbinsel','Panjiang-Halbinsel','Panjiang Peninsula'] _
,['Provinz_Kinya','Provinz Kinya','Kinya Province'] _
,['Saoshangweg','Saoshangweg','Saoshang Trail'] _
,['Sunqua-Tal','Sunqua-Tal','Sunqua Vale'] _
,['Zen_Daijun','Zen Daijun','Zen Daijun'] _
,['Bukdek-Seitenweg','Bukdek-Seitenweg','Bukdek Byway'] _
,['Nahpuiviertel','Nahpuiviertel','Nahpui Quarter'] _
,['Pongmei-Tal','Pongmei-Tal','Pongmei Valley'] _
,['Raisu-Palast','Raisu-Palast','Raisu Palace'] _
,['Schattenpassage','Schattenpassage','Shadow''s Passage'] _
,['Shenzun-Tunnel','Shenzun-Tunnel','Shenzun Tunnels'] _
,['Sunjiang-Bezirk','Sunjiang-Bezirk','Sunjiang District'] _
,['Tahnnakai-Tempel','Tahnnakai-Tempel','Tahnnakai Temple'] _
,['Waijun-Basar','Waijun-Basar','Wajjun Bazaar'] _
,['Xaquang-Himmelsweg','Xaquang-Himmelsweg','Xaquang Skyway'] _
,['Arborstein','Arborstein','Arborstone'] _
,['Drazachdickicht','Drazachdickicht','Drazach Thicket'] _
,['Der_Ewige_Hain','Der Ewige Hain','The Eternal Grove'] _
,['Farntal','Farntal','Ferndale'] _
,['Melandrus_Hoffnung','Melandrus Hoffnung','Melandru''s Hope'] _
,['Morostovweg','Morostovweg','Morostav Trail'] _
,['Trauerflorf%C3%A4lle','Trauerflorfälle','Mourning Veil Falls'] _
,['Archipel','Archipel','Archipelagos'] _
,['Boreas_Meeresgrund','Boreas Meeresgrund','Boreas Seabed'] _
,['Gyala-Brutst%C3%A4tte','Gyala-Brutstätte','Gyala Hatchery'] _
,['Maishang-H%C3%BCgel','Maishang-Hügel','Maishang Hills'] _
,['Quinkai','Quinkai','Mount Qinkai'] _
,['Rheas_Krater','Rheas Krater','Rhea''s Crater'] _
,['Stumme_Brandung','Stumme Brandung','Silent Surf'] _
,['Verschlafene_Gew%C3%A4sser','Verschlafene Gewässer','Unwaking Waters',"Dunes du Désespoir"] _
,['Fahranur,_die_Erste_Stadt','Fahranur, die Erste Stadt','Fahranur, The First City'] _
,['Felsen_von_Dohjok','Felsen von Dohjok','Cliffs of Dohjok'] _
,['Flachland_von_Jarin','Flachland von Jarin','Plains of Jarin'] _
,['Issnur-Inseln','Issnur-Inseln','Issnur Isles'] _
,['Lahtenda-Sumpf','Lahtenda-Sumpf','Lahtenda Bog'] _
,['Mehtani-Archipel','Mehtani-Archipel','Mehtani Keys'] _
,['Zehlon-Bucht','Zehlon-Bucht','Zehlon Reach'] _
,['Arkjok-Bastei','Arkjok-Bastei','Arkjok Ward'] _
,['Bahdok-H%c3%b6hlen','Bahdok-Höhlen','Bahdok Caverns'] _
,['Barbarenk%C3%BCste','Barbarenküste','Barbarous Shore'] _
,['Dejarin-Anwesen','Dejarin-Anwesen','Dejarin Estate'] _
,['Die_Schwemmebene_von_Mahnkelon','Die Schwemmebene von Mahnkelon','The Floodplain of Mahnkelon'] _
,['Gandara,_die_Mondfestung','Gandara, die Mondfestung','Gandara, the Moon Fortress'] _
,['Jahai-Klippen','Jahai-Klippen','Jahai Bluffs'] _
,['Marga-K%C3%BCste','Marga-Küste','Marga Coast'] _
,['Sonnenw%C3%A4rtige_S%C3%BCmpfe','Sonnenwärtige Sümpfe','Sunward Marches'] _
,['Turais_Weg','Turais Weg','Turai''s Procession'] _
,['Der_Spiegel_von_Lyss','Der Spiegel von Lyss','The Mirror of Lyss'] _
,['Forum-Hochland','Forum-Hochland','Forum Highlands'] _
,['G%C3%BCter_von_Chokhin','Güter von Chokhin','Holdings of Chokhin'] _
,['Makuun_die_Leuchtende','Makuun die Leuchtende','Resplendent Makuun'] _
,['Garten_von_Seborhin','Garten von Seborhin','Garden of Seborhin'] _
,['Vehjin-Minen','Vehjin-Minen','Vehjin Mines'] _
,['Vehtendi-Tal','Vehtendi-Tal','Vehtendi Valley'] _
,['Verborgene_Stadt_von_Ahdashim','Verborgene Stadt von Ahdashim','The Hidden City of Ahdashim'] _
,['Wildnis_von_Bahdza','Wildnis von Bahdza','Wilderness of Bahdza'] _
,['Yahtendi-Schluchten','Yahtendi-Schluchten','Yatendi Canyons'] _
,['Das_Alkalibecken','Das Alkalibecken','The Alkali Pan'] _
,['Das_Zerissene_Herz','Das Zerissene Herz','The Ruptured Heart'] _
,['Die_Schwefel-Ein%c3%b6de','Die Schwefel-Einöde','The Sulfurous Wastes'] _
,['Die_Zerkl%C3%BCfteten_Schluchten','Die Zerklüfteten Schluchten','The Shattered Ravines'] _
,['Giftige_Ausw%C3%BCchse','Giftige Auswüchse','Poisoned Outcrops'] _
,['Jokos_Dom%C3%A4ne','Jokos Domäne','Joko''s Domain'] _
,['Kristallspitze','Kristallspitze','Crystal Overlook'] _
,['Alcazia-Dickicht','Alcazia-Dickicht','Alcazia Tangle'] _
,['Arborbucht','Arborbucht','Arbor Bay'] _
,['Funkenschw%C3%A4rmersumpf','Funkenschwärmersumpf','Sparkfly Swamp'] _
,['Gr%C3%BCne_Kaskaden','Grüne Kaskaden','Verdant Cascades'] _
,['Magussteine','Magussteine','Magus Stones'] _
,['Zerrissene_Erde','Zerrissene Erde','Riven Earth'] _
,['Dalada-Hochlande','Dalada-Hochlande','Dalada Uplands'] _
,['Grothmar-Kriegshügel','Grothmar-Kriegshügel','Grothmar Wardowns'] _
,['Sacnoth-Tal','Sacnoth-Tal','Sacnoth Valley'] _
,['Bjora-S%C3%BCmpfe','Bjora-Sümpfe','Bjora Marches'] _
,['Drakkar-See','Drakkar-See','Drakkar Lake'] _
,['Eisklippen-Abgr%C3%BCnde','Eisklippen-Abgründe','Ice Cliff Chasms'] _
,['Jaga-Mor%C3%A4ne','Jaga-Moräne','Jaga Moraine'] _
,['Norrhart-Gebiete','Norrhart-Gebiete','Norrhart Domains'] _
,['Varajar-Moor','Varajar-Moor','Varajar Fells']]

;_ArrayDisplay($Vanq) Jaga-Mor%C3%A4ne

#EndRegion

#Region Wanted-Array definition
local $Wanted=[['Justiziarin_Kasandra','Justiziarin_Kasandra','Justiziarin_Kasandra'] _
,['Zaln_der_Ersch%C3%B6pfte','Zaln der Erschöpfte','boss not set','boss not set'] _
,['Carnak_der_Hungernde','Carnak der Hungernde','boss not set','boss not set'] _
,['Greves_der_Anma%C3%9Fende','Greves der Anmaßende','boss not set','boss not set'] _
,['Justiziarin_Kimii','Justiziarin Kimii','boss not set','boss not set'] _
,['Destor_der_Wahrheitssuchende','Destor der Wahrheitssuchende','boss not set','boss not set'] _
,['Justiziarin_Amilyn','Justiziarin Amilyn','boss not set','boss not set'] _
,['Justiziar_Marron','Justiziar Marron','boss not set','boss not set'] _
,['Justiziar_Sevaan','Justiziar Sevaan','boss not set','boss not set'] _
,['Vess_die_Streits%C3%BCchtige','Vess die Streitsüchtige','boss not set','boss not set'] _
,['Maximilian_der_Pingelige','Maximilian der Pingelige','boss not set','boss not set'] _
,['Cerris','Cerris','boss not set','boss not set'] _
,['Lev_die_Verdammte','Lev die Verdammte','boss not set','boss not set'] _
,['Sarnia_die_Roth%C3%A4ndige','Sarnia die Rothändige','boss not set','boss not set'] _
,['Vakar_der_Uners%C3%A4ttlichee','Vakar der Unersättliche','boss not set','boss not set'] _
,['Joh_der_Feindselige','Joh der Feindselige','boss not set','boss not set'] _
,['Barthimus_der_F%C3%BCrsorgliche','Barthimus der Fürsorgliche','boss not set','boss not set'] _
,['Amalek_der_Gnadenlose','Amalek der Gnadenlose','boss not set','boss not set'] _
,['Calamitous','Calamitous','boss not set','boss not set'] _
,['Selenas_die_Unverbl%C3%BCmte','Selenas die Unverblümte','boss not set','boss not set'] _
,['Valis_der_Ungez%C3%BCgelte','Valis der Ungezügelte','boss not set','boss not set']]
#EndRegion

#Region Combat-Array definition
local $Combat[][4]=[['Fort_Espenwald','Fort Espenwald','Fort Aspenwood'] _
,['Aufstieg_der_Helden','Aufstieg der Helden','Heroes Ascent','Random Arena'] _
,['B%C3%BCndnisk%C3%A4mpfe','Bündniskämpfe','Alliance Battles','Alliance Battles'] _
,['Gilde_gegen_Gilde','Gildenkämpfe','Guild versus Guild','Guild versus Guild'] _
,['Kodex-Arena','Kodex-Arena','Codex Arena','Codex Arena'] _
,['Zufallsarenen','Zufallsarenen','Random Arena','Random Arena'] _
,['Der_Jadesteinbruch','Der Jadesteinbruch','Jade Quarry','Jade Quarry']]
#EndRegion

#Region Bounty-Array definition

#Region Bounty-Array definition
local $Bounty[][4]=[['Faulschuppe','Faulschuppe','Rotscale','Rotscale'] _
,['Verata','Verata','Verata','Verata'] _
,['Das_Dunkel','Das Dunkel','The Darkness','The Darkness'] _
,['Kepkhet_Markschmaus','Kepkhet Markschmaus','Kepkhet Marrowfeast','Kepkhet Marrowfeast'] _
,['Der_Eiserne_Schmied','The Iron Forgeman','The Iron Forgeman','The Iron Forgeman'] _
,['Harn_und_Maxine_Coldstone','Harn und Maxine Coldstone','Harn and Maxine Coldstone','Harn and Maxine Coldstone'] _
,['Baubao_Wellenzorn','Baubao Wellenzorn','Baubao Wavewrath','Baubao Wavewrath'] _
,['Chung_der_Eingestimmte','Chung der Eingestimmte','Chung, the Attuned','Chung, the Attuned'] _
,['Ghial_der_Knochent%C3%A4nzer','Ghial der Knochentänzer','Ghial the Bone Dancer','Ghial the Bone Dancer'] _
,['Quansong_Geistsprecher','Quansong Geistsprecher','Quansong Spiritspeak','Quansong Spiritspeak'] _
,['Royen_Bestienw%C3%A4rter','Royen Bestienwärter','Royen Beastkeeper','Royen Beastkeeper'] _
,['Kanaxai','Kanaxai','Kanaxai','Kanaxai'] _
,['Kunvie_Feuerfl%C3%BCgel','Kunvie Feuerflügel','Kunvie Firewing','Kunvie Firewing'] _
,['Mohby_Windschnabel','Mohby Windschnabel','Mohby Windbeak','Mohby Windbeak'] _
,['Ssuns_der_von_Dwayna_Gesegnete','Ssuns der von Dwayna Gesegnete','Ssuns, Blessed of Dwayna','Ssuns, Blessed of Dwayna'] _
,['Arbor_Erdruf','Arbor Erdruf','Arbor Earthcall','Arbor Earthcall'] _
,['Mungri_Magiebox','Mungri Magiebox','Mungri Magicbox','Mungri Magicbox'] _
,['Urgoz','Urgoz','Urgoz','Urgoz'] _
,['Kommandeur_Wahli','Kommandeur Wahli','Commander Wahli','Commander Wahli'] _
,['Admiral_Kantoh','Admiral Kantoh','Admiral Kantoh','Admiral Kantoh'] _
,['Jarimiya_der_Gnadenlose','Jarimiya der Gnadenlose','Jarimiya the Unmerciful','Jarimiya the Unmerciful'] _
,['Korshek_der_Geopferte','Korshek der Geopferte','Korshek the Immolated','Korshek the Immolated'] _
,['Droajam,_Magier_des_Sandes','Droajam, Magier des Sandes','Droajam, Mage of the Sands','Droajam, Mage of the Sands'] _
,['Jedeh_der_M%C3%A4chtige','Jedeh der Mächtige','Jedeh the Mighty','Jedeh the Mighty'] _
,['F%C3%BCrst_Jadoth','Fürst Jadoth','Lord Jadoth','Lord Jadoth'] _
,['Das_Gro%C3%9Fe_Dunkel','Das Große Dunkel','The Greater Darkness','The Greater Darkness'] _
,['Die_Schwarze_Bestie_von_Arrgh','Die Schwarze Bestie von Arrgh','The Black Beast of Arrgh','The Black Beast of Arrgh'] _
,['Die_Stygischen_F%C3%BCrsten','Die Stygischen Fürsten','The Stygian Lords','The Stygian Lords'] _
,['Die_Stygischen_Unterf%C3%BCrsten','Die Stygischen Unterfürsten','The Stygian Underlords','The Stygian Underlords'] _
,['Arachni','Arachni','Arachni','Arachni'] _
,['Duncan_der_Schwarze','Duncan der Schwarze','Duncan the Black','Duncan the Black'] _
,['Eldritch-Ettin','Eldritch-Ettin','Eldritch-Ettin','Eldritch-Ettin'] _
,['Fendi_Nin','Fendi Nin','Fendi Nin','Fendi Nin'] _
,['Fronis_Eisenzehe','Fronis Eisenzehe','Fronis Irontoe','Fronis Irontoe'] _
,['Frostrachen_der_Sippenschl%C3%A4chter','Frostrachen der Sippenschlächter','Frostmaw the Kinslayer','Frostmaw the Kinslayer'] _
,['Havok_Seelenheuler','Havok Seelenheuler','Havok Soulwail','Havok Soulwail'] _
,['Ilsundur,_Herr_des_Feuers','Ilsundur, Herr des Feuers','Ilsundur, Lord of Fire','Ilsundur, Lord of Fire'] _
,['Justiziar_Thommis ','Justiziar Thommis ','Justiciar Thommis ','Justiciar Thommis '] _
,['Khabuus','Khabuus','Khabuus','Khabuus'] _
,['Magmus','Magmus','Magmus','Magmus'] _
,['Murakai,_Herrin_der_Nacht','Murakai, Herrin der Nacht','Murakai, Lady of the Night','Murakai, Lady of the Night'] _
,['Rand_Sturmweber','Rand Sturmweber','Rand Stormweaver','Rand Stormweaver'] _
,['Rragar_Menschenfresser','Rragar Menschenfresser','Rragar Maneater','Rragar Maneater'] _
,['Selvetarm','Selvetarm','Selvetarm','Selvetarm'] _
,['Seuche_der_Zerstörung ','Seuche der Zerstörung ','Plague of Destruction','Plague of Destruction'] _
,['Spektral-Schleim','Spektral-Schleim','Prismatic Ooze','Prismatic Ooze'] _
,['TPS-Regler-Golem','TPS-Regler-Golem','TPS Regulator Golem','TPS Regulator Golem'] _
,['%C3%9Cberrest_der_Vorzeit','Überrest der Vorzeit','Remnant of Antiquities','Remnant of Antiquities'] _
,["Z%27him_Monns","Z'him Monns","Z'him Monns","Z'him Monns"] _
,['Zoldark_der_Unheilige','Zoldark der Unheilige','Zoldark the Unholy','Zoldark the Unholy'] _
,['Schmiedewicht','Schmiedewicht','Forgewight','Forgewight'] _
,['Fenrir','Fenrir','Fenrir','Fenrir'] _
,['Myish,_Herrin_des_Sees','Myish, Herrin des Sees','Myish, Lady of the Lake','Myish, Lady of the Lake'] _
,['Nulfastu_Erdgebundener','Nulfastu Erdgebundener','Nulfastu, Earthbound','Nulfastu, Earthbound'] _
,['Borrguus_Raurinde','Borrguus Raurinde','Borrguus Blisterbark','Borrguus Blisterbark'] _
,['Fozzy_Yeoryio','Fozzy Yeoryio','Fozzy Yeoryio','Fozzy Yeoryio'] _
,['Molotov_Felsschweif','Molotov Felsschweif','Molotov Rocktail','Molotov Rocktail'] _
,['Joffs_der_Sanfte','Joffs der Sanfte','Joffs the Mitigator','Joffs the Mitigator'] _
,['Pywatt_der_Schnelle','Pywatt der Schnelle','Pywatt The Swift','Pywatt The Swift'] _
,['Mobrin,_Herr_des_Sumpfes','Mobrin, Herr des Sumpfes','Mobrin, Lord of the Marsh','Mobrin, Lord of the Marsh'] _
,["Menzies' Priester","Menzies' Priester","Priest of Menzies","Priest of Menzies"] _
,['Lord_Khobay','Lord Khobay','Lord Khobay','Lord Khobay'] _
,['Drachen-Lich','Drachen-Lich','Dragon Lich','Dragon Lich'] _
,['Rachs%C3%BCchtiger_Aatxe','Rachsüchtiger Aatxe','Vengeful Aatxe','Vengeful Aatxe'] _
,['Die_vier_Reiter','Die vier Reiter','The Four Horsemen','The Four Horsemen'] _
,['Geladene_Schw%C3%A4rze','Geladene Schwärze','Charged Blackness','Charged Blackness']]
#EndRegion

Func GetTodaysZaishen()
	local $a_Reg_Wanted ; regularExpression array for wanted

local $lang_strings[6][4] =[['dummy ','Zaishen-Bezwingung: ','Zaishen-Vanquish: ','Avis de recherche: '] _
,['dummy ','Heutige Zaishenquests: ','Todays Zaishenquests: ','Aujourd''hui: '] _
,['dummy ','Zaishen-Mission: ','Zaishen Mission: ','Mission zaishen: '] _
,['dummy ','Kopfgeld: ','Zaishen Bounty: ','Zaishen Bounty: '] _
,['dummy ','Zaishen-Kampf: ','Combat: ','Combat: '] _
,['dummy ','Gesucht: ','Wanted: ','Wanted: ']]

;query file
$txt = @scriptdir & "\query.txt"
FileDelete($txt)
$handlef=filewrite($txt,$original)

Global $Line=_FileCountLines($txt)
fileclose($handlef)
local $aRecords[$Line][1] ; declare array-size by lines of txtfile

		If Not _FileReadToArray($txt,$aRecords) Then
			MsgBox(4096,"Error", " Error reading log to Array. No Internet?     error:" & @error)
			Exit
		EndIf
;_arraydisplay($aRecords)

For $x = 0 to $Line -1

	If StringRegExp($aRecords[$x],'<tr style="font-weight:bold;',0) Then ExitLoop

	Next
			;get mission
			$v_bounty=$aRecords[$x+3]
			$a_bounty=_Stringbetween($v_bounty,'</td><td>  <a href="/wiki/','_(Zaishen-Kopfgeld)',0) ; puts result of stringbetween to array
			$mission=$aRecords[$x+2]
			;ConsoleWrite($mission)
			$a_mission=_Stringbetween($mission,'<a href="/wiki/','_(Zaishen-Mission)" title="',0) ; puts result of stringbetween to array
			if not IsArray($a_mission) then msgbox(0,"no","no")
			$v_combat=$aRecords[$x+4]
			$a_combat=_Stringbetween($v_combat,'</td><td>  <a href="/wiki/','_(Zaishen-Kampf)" title="',0) ; puts result of stringbetween to array
			;_ArrayDisplay($a_combat)
			$vanquish=$aRecords[$x+5]
			$a_vanquish=_Stringbetween($vanquish,'</td><td>  <a href="/wiki/','_(Zaishen-Bezwingung)" title="',0) ; puts result of stringbetween to array
			$v_wanted=$aRecords[$x+6]
			$a_wanted=_Stringbetween($v_wanted,'</td><td>  <a href="/wiki/Gesucht:_','" title="Gesucht:',0) ; puts result of stringbetween to array



				;_ArrayDisplay($a_mission) ;debug
				;get Mission language and pic
				local $i = 0
				#Region get Mission lang
					For $nz = 0 To UBound($Missionen) - 1
						If StringRegExp($Missionen[$nz][0], $a_mission[0], 0) Then

							$i = $nz
							exitloop
;~ 						Else
;~ 									msgbox(0,"String not found","The String: " &$a_mission[0] & " was not found in the array 'Mission' The result for it is wrong")
;~ 									exitloop
						EndIf
					Next
					#Region getpic
							$getpic = InetRead("http://www.guildwiki.de/wiki/" & "Datei:" & StringRegExpReplace($Missionen[$i][1], " ", "_") & ".jpg"); language needs  to be 1=german here
							$bgetpic = BinaryToString($getpic)
							Local $missionpicurls = _stringbetween($bgetpic, "gwiki/images/", ".jpg")
							$piclink = "http://www.guildwiki.de/gwiki/images/" & $missionpicurls[0] & ".jpg"
							InetGet($piclink, "mission.jpg")
							local $p_mission = @scriptdir & "\mission.jpg"
					#EndRegion getpic
				#EndRegion get Mission lang

						#Region get Vanquish
						Local $No = 0
							For $o = 0 To UBound($Vanq) - 1
								If StringRegExp($Vanq[$o][0], $a_vanquish[0], 0) Then
									$No = $o
									exitloop
;~ 								Else
;~ 									msgbox(0,"String not found","The String: " &$a_vanquish[0] & " was not found in the array 'Vanquish' The result for it is wrong")
									exitloop
 								EndIf
							next
						#EndRegion get Vanquish

							#Region get Wanted
								local $NP = 0
								For $p = 0 To UBound($Wanted) - 1
									If StringRegExp($Wanted[$p][0], $a_wanted[0], 0) Then
										$NP = $p
										exitloop
;~ 									Else
;~ 									msgbox(0,"String not found","The String: " &$a_wanted[0] & " was not found in the array 'Wanted' The result for it is wrong")
;~ 									exitloop

 									Endif

								next
							#EndRegion get Wanted

								#Region get Combat
									local $NZ = 0
									For $z = 0 To UBound($Combat) - 1
										If StringRegExp($Combat[$z][0], $a_combat[0], 0) Then
											$NZ = $z
											exitloop
;~ 										Else
;~ 										msgbox(0,"String not found","The String: " &$a_combat[0] & " was not found in the array 'Combat' The given result for it is wrong")
;~ 										exitloop
										Endif

									next
								#EndRegion get Combat

									#Region get Bounty
									local $NX = 0
										For $n = 0 To UBound($Bounty) - 1
										If StringRegExp($Bounty[$n][0], $a_bounty[0], 0) Then
											$NX = $n
											exitloop
;~ 										Else
;~ 											msgbox(0,"String not found","The String: " &$a_bounty[0] & " was not found in the array 'Bounty' The given result for it is wrong")
;~ 											exitloop
 										Endif

										next
									#EndRegion get Bounty


				$s_zaishen="<" &$lang_strings[3][$language]&">"& @crlf & $Bounty[$NX][$language] & @crlf & @crlf &  "<"&$lang_strings[2][$language]& ">"& @crlf &$Missionen[$i][$language] _
				& @crlf & @crlf &"<" &$lang_strings[4][$language]&">"& @crlf & $Combat[$NZ][$language] & @crlf & @crlf &"<" &$lang_strings[0][$language]& ">"& @crlf &$Vanq[$No][$language]& @crlf & @crlf & _
				"<" & $lang_strings[5][$language]&">"& @crlf &$Wanted[$NP][$language]

				_Toast_Show($p_mission, $lang_strings[1][$language],"" & @crlf & $s_zaishen)
				sleep(8000)
 EndFunc
exit
