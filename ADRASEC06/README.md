# Modèle Winlink ADRASEC 06 — Message d'ambiance / situation / encapsulé

Formulaire unique avec bascule automatique selon le **type de message** choisi.

## Fichiers

| Fichier | Rôle |
|---|---|
| `Message ADRASEC 06.txt` | Définition du modèle (c'est ce nom qui apparaît dans la liste Winlink). Encodage UTF-8 avec BOM, fins de ligne CRLF. |
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

Les champs masqués sont vidés à l'envoi : le texte transmis ne contient que les rubriques utiles.

## Variables transmises

| Variable | Contenu |
|---|---|
| `vType` | `AMBIANCE`, `SITUATION` ou `ENCAPSULE` (utilisé dans le sujet) |
| `vTypeLib` | Libellé en clair, calculé à l'envoi |
| `vNumero` | N° du message (pré-rempli par `{SeqNum}`, auto-incrémenté via `SeqInc:`) |
| `Priority` | `IMMEDIAT` / `URGENT` / `ROUTINE` |
| `Dem_Rep` | `Oui` / `Non` |
| `vDate`, `vHeure` | Date et heure, bascule UTC / Locale par le bouton |
| `vOrigine` | Indicatif de la station émettrice (pré-rempli par `{msgSender}`) |
| `vTo` | Indicatifs destinataires séparés par `;` |
| `vAutOrig`, `vAutDest` | Autorités (encapsulé uniquement) |
| `vSujet` | Sujet saisi (encapsulé) ou généré automatiquement (ambiance / situation) |
| `vMessage` | Texte de l'autorité (encapsulé uniquement) |
| `vJeSuis`, `vJeVois`, `vJeFais`, `vJeDemande` | Rubriques SOIE |
| `vCorps` | Corps mis en forme, assemblé à l'envoi — c'est lui qui est imprimé dans le message texte |

Le sujet du message Winlink prend la forme : `[ROUTINE][AMBIANCE/017] MESSAGE D'AMBIANCE du 2026-09-10 14:32 (UTC)`

## Personnalisation

**Logos** — le logo ADRASEC 06 (à gauche) et l'emblème de la protection civile (à droite) sont intégrés directement en **SVG vectoriel** dans les deux fichiers HTML : pas d'image externe, pas de base64, et un rendu net à l'écran comme à l'impression.

Le fichier `logo_adrasec06.svg` est fourni à part pour d'autres usages (site, courrier, QSL) ; `logo_adrasec06.png` en est un export 512 px.

Pour ajuster la taille dans le bandeau, modifier la règle :

```css
.header svg.logo { height: 110px; width: auto; }
```

Pour retoucher les couleurs, modifier les dégradés `adrOrange` / `adrBleu` (logo) et `pcOrange` / `pcBleu` (emblème) en haut de chaque SVG. Les teintes actuelles : orange `#FFB347 → #D95E00`, bleu `#3F5CFF → #0A159E`, texte `#0F1FBE`.

**Version** — trois endroits : la balise `<meta name="version">`, le champ caché `TemplateVersion` de l'Initial, et le pied de page des deux fichiers.

**Accents** — les accents sur les majuscules sont supprimés à l'envoi (`removeUppercaseAccent`) et les accents minuscules sont restaurés à l'affichage (`setacc`), comme dans les modèles FNRASEC.

## Points de vérification avant mise en service

1. Ouvrir `ADRASEC06_Message_Initial.html` dans un navigateur : basculer entre les trois types et vérifier l'affichage.
2. Faire un envoi réel vers soi-même (`vTo` = son propre indicatif) et contrôler le rendu du texte et du Viewer.
3. Vérifier le comportement de l'auto-incrémentation `SeqInc:` sur deux messages consécutifs.

## Accusé de réception

Le modèle principal déclare `ReplyTemplate: AR ADRASEC 06.txt` : le destinataire qui clique sur **Reply** dans Winlink obtient directement le formulaire d'accusé, pré-rempli.

| Champ | Origine |
|---|---|
| N° de l'AR | `{MsgOriginalID}`, sinon `{SeqNum}` |
| Date / Heure | horloge, bouton UTC / LOC |
| Origine | `{Callsign}` |
| Destinataire | `{MsgOriginalSender}` |
| Référence du message accusé | `{MsgOriginalSubject}` |
| Priorité | saisie, ROUTINE par défaut |
| Commentaire | saisie, obligatoire |

Cette ligne doit toujours pointer vers un **autre** fichier `.txt` existant. Une auto-référence provoque l'erreur :

> Error writing form data to RMS_Express_Form_..._Viewer.html ReplyTemplate: ...xml : Caractères non conformes dans le chemin d'accès.

Si cette erreur réapparaît, le nom de fichier est le suspect suivant : renommer `AR ADRASEC 06.txt` sans espaces et reporter le nouveau nom dans la ligne `ReplyTemplate:`.


Gabarit visuel repris des modèles FNRASEC de F4IXH (Jean-Louis Zola), sous licence MIT.
