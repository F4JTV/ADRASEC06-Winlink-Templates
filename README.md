# Modèle Winlink ADRASEC 06 — Message d'ambiance / situation / encapsulé

Formulaire unique avec bascule automatique selon le **type de message** choisi.

## Fichiers

| Fichier | Rôle |
|---|---|
| `Message ADRASEC 06.txt` | Définition du modèle (c'est ce nom qui apparaît dans la liste). ASCII pur, sans BOM, fins de ligne CRLF. |
| `ADRASEC06_Message_Initial.html` | Formulaire de saisie |
| `ADRASEC06_Message_Viewer.html` | Affichage / impression du message reçu |
| `AR ADRASEC 06.txt` | Définition du modèle d'accusé de réception |
| `ADRASEC06_AR_Initial.html` | Formulaire d'accusé de réception |
| `ADRASEC06_AR_Viewer.html` | Affichage / impression de l'accusé reçu |

Les trois fichiers sont autonomes : CSS et JavaScript sont intégrés, aucune dépendance externe.

## Installation

Copier les trois fichiers dans un sous-dossier de :

```
C:\RMS Express\Global Folders\Templates\ADRASEC06\
```

Puis dans Winlink Express : *Message > New Message > Select Template* → dossier `ADRASEC06` → `Message ADRASEC 06`.

## Comportement du formulaire

- **Message d'ambiance** / **Message de situation** → affiche les rubriques **Je suis / Je vois / Je fais / Je demande**. *Je suis*, *Je vois* et *Je fais* sont obligatoires, *Je demande* est facultatif.
- **Message encapsulé** → affiche **Autorité d'origine**, **Autorité destinataire**, **Sujet** et **Message de l'autorité**, tous obligatoires.
- **Procédure codifiée** → affiche les six rubriques normalisées :

| Rubrique | Saisie |
|---|---|
| PAPA (position) | Commune + coordonnées + sélecteur de format (D° M' S", D° M.mmm', degrés décimaux) |
| SIERRA (station) | Fixe / Mobile / Portable — choix unique |
| GOLF (gamme) | HF / VHF / UHF / QO100 — cases à cocher, plusieurs possibles, au moins une exigée |
| ECHO (électrique) | Secteur / Groupe électrogène / Panneaux solaires / Éolienne / Batterie — choix unique |
| ALPHA (autonomie) | Nombre d'heures |
| DELTA (disponibilité) | Nombre + unité Heures ou Minutes |

  Un commentaire libre facultatif complète le bloc ; il n'apparaît dans le message et dans le viewer que s'il est rempli.

Les champs masqués sont vidés à l'envoi : le texte transmis ne contient que les rubriques utiles.

## Variables transmises

| Variable | Contenu |
|---|---|
| `vType` | `AMBIANCE`, `SITUATION`, `ENCAPSULE` ou `CODIFIEE` (utilisé dans le sujet) |
| `vTypeLib` | Libellé en clair, calculé à l'envoi |
| `vNumero` | N° du message (pré-rempli par `{SeqNum}`, auto-incrémenté via `SeqInc:`) |
| `Priority` | `IMMEDIAT` / `URGENT` / `ROUTINE` |
| `Dem_Rep` | `Oui` / `Non` |
| `vDate`, `vHeure` | Date et heure locales, suffixées `(LOC)` |
| `vOrigine` | Indicatif de la station émettrice (pré-rempli par `{msgSender}`) |
| `vTo` | Indicatifs destinataires séparés par `;` |
| `vAutOrig`, `vAutDest` | Autorités (encapsulé uniquement) |
| `vSujet` | Sujet saisi (encapsulé) ou généré automatiquement (ambiance / situation) |
| `vMessage` | Texte de l'autorité (encapsulé uniquement) |
| `vJeSuis`, `vJeVois`, `vJeFais`, `vJeDemande` | Rubriques SOIE |
| `vPapaCommune`, `vPapaGPS`, `vPapaFormat` | Rubrique PAPA |
| `vSierra`, `vEcho` | Rubriques SIERRA et ECHO |
| `vGolf` | Gammes cochées, assemblées à l'envoi (`HF, VHF`) |
| `vAlpha`, `vDelta`, `vDeltaUnite` | Rubriques ALPHA et DELTA |
| `vCommentaire` | Commentaire de la procédure codifiée |
| `vCorps` | Corps mis en forme, assemblé à l'envoi — c'est lui qui est imprimé dans le message texte |

Le sujet du message Winlink prend la forme : `[ROUTINE][AMBIANCE/017] MESSAGE D'AMBIANCE du 2026-09-10 14:32 (LOC)`

## Personnalisation

**Logos** — le logo ADRASEC 06 (à gauche) et l'emblème de la protection civile (à droite) sont intégrés directement en **SVG vectoriel** dans les deux fichiers HTML : pas d'image externe, pas de base64, et un rendu net à l'écran comme à l'impression.

Le fichier `logo_adrasec06.svg` est fourni à part pour d'autres usages (site, courrier, QSL) ; `logo_adrasec06.png` en est un export 512 px.

Pour ajuster la taille dans le bandeau, modifier la règle :

```css
.header svg.logo { height: 110px; width: auto; }
```

Pour retoucher les couleurs, modifier les dégradés `adrOrange` / `adrBleu` (logo) et `pcOrange` / `pcBleu` (emblème) en haut de chaque SVG. Les teintes actuelles : orange `#FFB347 → #D95E00`, bleu `#3F5CFF → #0A159E`, texte `#0F1FBE`.

**Version** — trois endroits : la balise `<meta name="version">`, le champ caché `TemplateVersion` de l'Initial, et le pied de page des deux fichiers.

**Heure** — la date et l'heure sont toujours locales, renseignées automatiquement à l'ouverture du formulaire et modifiables à la main. L'heure porte le suffixe `(LOC)` pour lever toute ambiguïté chez le destinataire.

**Accents** — les accents sur les majuscules sont supprimés à l'envoi (`removeUppercaseAccent`) et les accents minuscules sont restaurés à l'affichage (`setacc`), comme dans les modèles FNRASEC.

## Points de vérification avant mise en service

1. Ouvrir `ADRASEC06_Message_Initial.html` dans un navigateur : basculer entre les quatre types et vérifier l'affichage.
2. Faire un envoi réel vers soi-même (`vTo` = son propre indicatif) et contrôler le rendu du texte et du Viewer.
3. Vérifier le comportement de l'auto-incrémentation `SeqInc:` sur deux messages consécutifs.

## Installateur Windows

Le dossier contient un script **Inno Setup 6** qui produit un `.exe` d'installation, pratique pour déployer les modèles sur les postes de l'association sans manipulation de dossiers.

Compilation, depuis le dossier qui contient `ADRASEC06_Templates.iss` :

```
"C:\Program Files (x86)\Inno Setup 6\ISCC.exe" ADRASEC06_Templates.iss
```

Le résultat, `ADRASEC06_Templates_Setup_1.0.0.exe`, est autonome et distribuable tel quel.

Ce que fait l'installateur :

- il cherche Winlink Express dans les emplacements habituels et pré-remplit le dossier ; si `RMS Express.exe` est absent du dossier choisi, il prévient sans bloquer ;
- il écrit les modèles dans `<Winlink>\Global Folders\Templates\ADRASEC06` ;
- une case à cocher facultative dépose en plus une copie sur le Bureau, dans `ADRASEC06_WoAD`, avec un rappel de la marche à suivre pour le téléphone ;
- il s'inscrit dans Ajout/Suppression de programmes et sait se désinstaller, en supprimant uniquement son propre sous-dossier de modèles.

Fichiers du projet d'installation : `ADRASEC06_Templates.iss`, `setup_icon.ico`, `setup_wizard.bmp`, `setup_wizard_small.bmp`. Ils doivent rester à côté du dossier `ADRASEC06`, qui fournit les fichiers à installer.

Pour changer de version, modifier `#define AppVersion` en tête du script ; le nom du `.exe` produit suit automatiquement.

## Winlink Express et WoAD

Les mêmes fichiers servent aux deux applications, sans adaptation. Ce qui change, c'est l'emplacement où les déposer.

**Winlink Express** : un sous-dossier de `C:\RMS Express\Global Folders\Templates\`.

**WoAD** : les fichiers doivent être dans le dossier applicatif de WoAD, soit `Android/data/com.sumusltd.woad/files/`, et *Settings → Message template → Other templates location* réglé sur **App-specific External** avec le chemin par défaut.

Un dossier partagé sélectionné via le sélecteur de fichiers Android ne convient pas : WoAD y liste bien les `.txt`, mais n'ouvre pas les `.html` voisins. Il retombe alors silencieusement en mode texte et affiche le modèle brut, avec les `<var ...>` non résolus — symptôme trompeur qui ressemble à un défaut du modèle alors que les fichiers sont corrects.

Le dossier `Android/data/...` est masqué par les explorateurs de fichiers Android ; le plus simple est de brancher le téléphone en USB et d'y copier les fichiers depuis un ordinateur. Redémarrer WoAD complètement après la copie.

À savoir également : la WebView de WoAD **bloque `localStorage`**, ce qui casse certains modèles standards Winlink. Aucun de ces formulaires ne s'en sert.

## Accusé de réception

Le modèle principal déclare `ReplyTemplate: AR ADRASEC 06.txt` : le destinataire qui clique sur **Reply** dans Winlink obtient directement le formulaire d'accusé, pré-rempli.

| Champ | Origine |
|---|---|
| N° de l'AR | `{MsgOriginalID}`, sinon `{SeqNum}` |
| Date / Heure | horloge locale |
| Origine | `{Callsign}` |
| Destinataire | `{MsgOriginalSender}` |
| Référence du message accusé | `{MsgOriginalSubject}` |
| Priorité | saisie, ROUTINE par défaut |
| Commentaire | saisie, obligatoire |

Cette ligne doit toujours pointer vers un **autre** fichier `.txt` existant. Une auto-référence provoque l'erreur :

> Error writing form data to RMS_Express_Form_..._Viewer.html ReplyTemplate: ...xml : Caractères non conformes dans le chemin d'accès.

Si cette erreur réapparaît, le nom de fichier est le suspect suivant : renommer `AR ADRASEC 06.txt` sans espaces et reporter le nouveau nom dans la ligne `ReplyTemplate:`.


Gabarit visuel repris des modèles FNRASEC de F4IXH (Jean-Louis Zola), sous licence MIT.
