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

Le projet contient un script **Inno Setup 6** qui produit un `.exe` d'installation, pratique pour déployer les modèles sur les postes de l'association sans manipulation de dossiers.

Compilation, depuis le dossier qui contient `ADRASEC06_Templates.iss` :

```
"C:\Program Files (x86)\Inno Setup 6\ISCC.exe" ADRASEC06_Templates.iss
```

Le résultat, `Modeles_Winlink_Setup_1.1.1.exe`, est autonome et distribuable tel quel.

### Jeux de modèles proposés

L'assistant demande ce qu'il faut installer :

| Choix | Contenu | Dossier installé |
|---|---|---|
| Les deux (par défaut) | ADRASEC 06 + FNRASEC | les deux ci-dessous |
| ADRASEC 06 uniquement | message (ambiance / situation / encapsulé / procédure codifiée) et accusé de réception | `Templates\ADRASEC06` |
| FNRASEC uniquement | les six formulaires officiels FNRASEC 25.10.1 | `Templates\FNRASEC` |
| Personnalisée | cases à cocher libres | — |

Les deux jeux sont indépendants : ils vivent dans des sous-dossiers distincts et apparaissent comme deux groupes séparés dans la liste des modèles de Winlink.

### Ce que fait l'installateur

- il cherche Winlink Express dans les emplacements habituels et pré-remplit le dossier ; si `RMS Express.exe` est absent du dossier choisi, il prévient sans bloquer ;
- il écrit les modèles dans `<Winlink>\Global Folders\Templates\<jeu>` ;
- si un dossier de modèles existe déjà, il demande confirmation avant de le remplacer ;
- une case à cocher facultative dépose en plus une copie sur le Bureau, dans `Winlink_WoAD`, avec un rappel de la marche à suivre pour le téléphone ; cette copie est **à plat**, tous jeux confondus, parce que WoAD ne descend pas de façon fiable dans les sous-dossiers ;
- il s'inscrit dans Ajout/Suppression de programmes et sait se désinstaller, en ne supprimant que les dossiers des jeux réellement installés.

### Numéro de version

Les modèles ADRASEC 06 et l'installateur portent **le même numéro**, aujourd'hui `1.1.1`. C'est celui que chaque message transmet sous `Template Version`, celui qu'affiche le pied de page des formulaires, et celui du `.exe` produit.

Ce numéro figure à sept endroits, et les éditer à la main les fait dériver. Le script `set-version.ps1` les met tous à jour d'un coup :

```
.\set-version.ps1 1.1.2
```

Il ne touche qu'aux fichiers ADRASEC 06 et au `.iss`, préserve l'encodage de chacun — le `.iss` a besoin de son BOM pour les accents, les HTML n'en ont pas — et laisse le dossier `FNRASEC` intact, puisque sa version `25.10.1` appartient à ses auteurs. Recompiler l'installateur après coup.

### Fichiers du projet d'installation

`ADRASEC06_Templates.iss`, `set-version.ps1`, `setup_icon.ico`, `setup_wizard.bmp`, `setup_wizard_small.bmp`, plus les dossiers `ADRASEC06` et `FNRASEC` qui fournissent les fichiers à installer.

Pour changer de version, utiliser `set-version.ps1` plutôt que d'éditer `#define AppVersion` seul, afin que les modèles et l'installateur restent en phase ; le nom du `.exe` produit suit automatiquement.

### Modèles FNRASEC

Ce sont les modèles officiels de la FNRASEC en version **25.10.1**, œuvre de Jean-Louis Zola (F4IXH), redistribués sous licence MIT. La notice de copyright les accompagne dans le dossier `FNRASEC`, sous le nom `LICENSE_FNRASEC.md`.

L'extension `.md` n'est pas un détail : Winlink liste **tout** fichier `.txt` d'un dossier de modèles comme un modèle, donc une licence nommée `.txt` apparaîtrait comme une entrée fantôme dans la liste.

Les six fichiers `.txt` portent leur nom canonique, `FNRASEC <titre> 25.10.1.txt`, qui est aussi celui que la ligne `ReplyTemplate:` des cinq autres formulaires référence. Les renommer casserait la réponse automatique par accusé de réception.

Pour passer à une version ultérieure des modèles FNRASEC : remplacer le contenu du dossier `FNRASEC`, en conservant la correspondance entre les noms de fichiers et les lignes `Form:` et `ReplyTemplate:` qu'ils contiennent.

## Winlink Express et WoAD

Les mêmes fichiers servent aux deux applications, sans adaptation. Ce qui change, c'est l'emplacement où les déposer.

**Winlink Express** : un sous-dossier de `C:\RMS Express\Global Folders\Templates\`.

**WoAD** : les fichiers doivent être dans le dossier applicatif de WoAD, soit `Android/data/com.sumusltd.woad/files/`, et *Settings → Message template → Other templates location* réglé sur **App-specific External** avec le chemin par défaut.

Un dossier partagé sélectionné via le sélecteur de fichiers Android ne convient pas : WoAD y liste bien les `.txt`, mais n'ouvre pas les `.html` voisins. Il retombe alors silencieusement en mode texte et affiche le modèle brut, avec les `<var ...>` non résolus — symptôme trompeur qui ressemble à un défaut du modèle alors que les fichiers sont corrects.

Le dossier `Android/data/...` est masqué par les explorateurs de fichiers Android ; le plus simple est de brancher le téléphone en USB et d'y copier les fichiers depuis un ordinateur. Redémarrer WoAD complètement après la copie.

### Format des fichiers `.txt` : pas de BOM

**Les fichiers de définition `.txt` doivent être enregistrés en UTF-8 _sans_ BOM**, avec des fins de ligne CRLF. Les accents dans le corps ne posent aucun problème.

`Form:` est la première ligne du fichier. Un BOM UTF-8 la préfixe de trois octets invisibles, WoAD ne reconnaît plus le mot-clé, ignore donc le formulaire HTML et ouvre le modèle en texte brut avec tous les `<var ...>` non résolus. Winlink Express, lui, tolère ce BOM — d'où un modèle qui fonctionne d'un côté et pas de l'autre.

Les modèles FNRASEC sont enregistrés sans BOM et avec accents : c'est la référence à suivre, et la comparaison des deux jeux côte à côte dans le même dossier est le moyen le plus rapide de vérifier ce point en cas de doute.

Attention aux éditeurs Windows : le Bloc-notes ajoute un BOM quand on choisit « UTF-8 » dans l'ancienne boîte d'enregistrement. Sous Notepad++, choisir « UTF-8 » et non « UTF-8-BOM ».

### Installer les modèles sur le téléphone

**Les fichiers doivent être à plat dans `Android/data/com.sumusltd.woad/files/`, sans aucun sous-dossier.**

WoAD retrouve les `.txt` même rangés dans un sous-dossier, et les affiche donc dans la liste des modèles, mais il cherche les `.html` à la racine du dossier configuré. Déballer l'archive du projet telle quelle crée `files/ADRASEC06/` et `files/FNRASEC/`, et à partir de là chaque modèle s'ouvre en texte brut — avec le même symptôme que le BOM ci-dessus, pour une cause différente.

L'archive `WoAD_Templates.zip` contient les mêmes fichiers déjà à plat, prêts à être déposés dans `files/`. L'installateur Windows produit la même chose dans son dossier `Winlink_WoAD` sur le Bureau.

Après copie, redémarrer WoAD complètement. S'il reste d'anciens sous-dossiers dans `files/`, les supprimer : leurs `.txt` continueraient d'apparaître en double dans la liste.

Winlink Express, lui, gère très bien les sous-dossiers et s'en sert pour grouper les modèles par jeu — d'où la différence de traitement entre les deux.

### Lire un message reçu dans WoAD

WoAD affiche d'abord le corps du message en texte brut. Le formulaire mis en page s'ouvre en **touchant le lien de la pièce jointe XML** affiché sous l'en-tête, par exemple `RMS_Express_Form_ADRASEC06_Message_Viewer.xml`.

WoAD cherche alors le fichier HTML dont ce nom dérive — ici `ADRASEC06_Message_Viewer.html` — dans son dossier de modèles. Le `_Viewer.html` doit donc être présent sur le téléphone, et pas seulement le `_Initial.html` qui sert à la rédaction.

Si rien ne s'ouvre au toucher, c'est que WoAD ne trouve pas ce fichier : vérifier qu'il est bien dans `Android/data/com.sumusltd.woad/files/`, au même niveau que les autres.

### Répondre par un accusé de réception sous WoAD

WoAD ouvre bien le formulaire d'accusé quand on touche Répondre, et le XML joint porte les valeurs saisies. En revanche, **le corps texte du message est composé avec les données du message auquel on répond** dès qu'une variable porte le même nom dans les deux modèles.

C'est pourquoi toutes les variables de l'accusé portent un préfixe `ar` : `arNumero`, `arPriority`, `arDate`, `arHeure`, `arSender`, `arOrigine`, `arTo`, `arRef`, `arCommentaire`, `arVersion`. Aucune ne peut entrer en collision avec celles du modèle Message, donc chacune garde la valeur saisie.

Sans cette précaution, l'accusé reprenait la priorité, la date, l'heure et le numéro du message d'origine, et surtout son `vTo` — ce qui l'envoyait au destinataire du message d'origine au lieu de son expéditeur.

**Toute variable ajoutée plus tard au modèle d'accusé doit garder ce préfixe**, sous peine de réintroduire le défaut silencieusement.

### Numéro de l'accusé

Le numéro est celui du compteur de séquence de la station (`{SeqNum}`), pas l'identifiant interne du message accusé (`{MsgOriginalID}`), qui est une chaîne du type `1SNY4XKF0RMR` inexploitable à l'oral comme sur un journal papier. Le lien avec le message accusé est porté par le champ **Référence du message accusé**, qui en reprend le sujet complet avec son propre numéro.

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
