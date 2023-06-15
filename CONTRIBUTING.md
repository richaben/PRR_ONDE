# Contribution au PRR ONDE

## Dépôt de référence

Le dépôt de référence du projet est hébergé sur Github: <https://github.com/richaben/PRR_ONDE>. Les mises-à-jour du code de l'application doivent d'abord être intégrées dans la branche principale de dépôt pour être accessibles aux différentes déclinaisons régionales de l'outil (voir [la procédure d'installation](https://github.com/richaben/PRR_ONDE/blob/master/Install.md#installation-de-loutil)).

Ce document décrit les grands principes permettant de structurer les contributions à l'outil via ce dépôt de référence. Ces contributions nécessitent de disposer d'un compte GitHub.

## Tickets

Les signalements de bug, demandes de corrections ou d'évolutions doivent être remontés via [l'outil `Issues` du dépôt de référence](https://github.com/richaben/PRR_ONDE/issues),.

Afin de faciliter le traitement de ces demandes, il est recommandé d'être **le plus précis possible** dans la description des problèmes rencontrés ou des évolutions demandées. Des captures d'écran peuvent être utilement mises à contribution. Il est **fortement recommandé d'utiliser les modèles de formulaire fournis** pour les trois principaux types de demandes (signalement de problèmes, demande d'évolution, demande de documentation).

Il est également recommandé de **lire les tickets déjà ouverts afin de vérifier que le problème rencontré n'a pas déjà été signalé**. Si le problème est le même, il est préférable de compléter sa description, de signaler qu'il est observé par d'autres dans le ticket d'origine plutôt que d'en ouvrir un nouveau.

Les contributeurs au dépôt de référence peuvent attribuer des étiquettes *(labels)* aux tickets ouverts afin de les classer dans plusieurs catégories, dont :

-   **bug**: signalement d'erreurs ou de mauvais fonctionnement;

-   **enhancement**: proposition d'amélioration de l'application (ergonomie, fonctionnalité...)

-   **documentation**: besoin d'ajout ou de précision dans la documentation

Les tickets ouverts à l'aide des modèles de formulaires se voient automatiquement attribuer l'étiquette correspondant au type de formulaire.

## Contribution au code

Il est également possible de contribuer à l'amélioration de l'outil plus directement via des modifications du code et de la documentation.

Afin de faciliter le travail d'intégration de ces contributions, un certain nombre de recommendations sont nécessaires.

### Principe

Le travail de développement ne se fait pas directement sur le dépôt de référence mais sur des copies ([fork](https://docs.github.com/fr/pull-requests/collaborating-with-pull-requests/working-with-forks/about-forks)) de ce dépôt par les contributeurs, ce qui leur permet de tester les modifications et ajouts proposées sans risque d'impacter le dépôt de référence.

Les propositions de modifications sont ensuite proposées ([Pull request](https://docs.github.com/fr/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests)) au dépôt de référence dont les contributeurs principaux évalueront la pertinence et la faisabilité de l'intégration.

### Branches

Un dépôt peut contenir plusieurs lignes de développement en parallèle, ce que l'on appelle des [branches](https://docs.github.com/fr/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-branches). Les modifications apportées dans une branche n'affectent pas le code des autres branches.

#### Le dépôt de référence

Le dépôt de référence du PRR Onde est composé de trois branches:

-   **`master`**: c'est la branche principale, celle qui retrace l'historique des modifications du code de l'application. Il est souhaité que l'historique de cette branche soit le plus propre possible afin de faciliter sa lecture et de **visualiser rapidement les principales étapes et évolutions du code**. **Cette branche ne doit pas être modifiée directement**;

-   **`deploy`**: il s'agit d'une copie de la branche principale qui récupère automatiquement les modifications apportées à cette dernière. C'est également sur cette branche que sont effectuées automatiquement les mise-à-jour des données et le déploiement de la page HTML générée. **Cette branche ne doit pas être modifiée manuellement**;

-   **`dev`**: il s'agit de la branche de travail sur laquelle vont **être enregistrées toutes les modifications du code**. Afin de faciliter le travail collaboratif, **l'idéal est de ne pas travailler directement sur cette branche mais d'y intégrer les propositions de modification des collaborateurs en utilisant des Pull requests**. Une fois un certain nombre de modifications intégrées et testées dans la branche `dev`, il convient alors de les intégrer dans la branche principale.

#### Les dépôts dupliqués des contributeurs

En plus des trois branches mentionnées pour le dépôt de référence, les dépôts des contributeurs, sur lesquels sont fait les travaux de développement, vont contenir des branches supplémentaires. Ces branches vont servir à enregistrer les modifications du code proposées pour intégration dans le dépôt de référence. Chaque branche est créée à partir de la branche `dev` et **correspond à une proposition de modification spécifique** (ajout d'une fonctionnalité, correction d'un bug, ajout/modification de documentation...).

#### Règles de nommage

Afin de faciliter le suivi des propositions de modification, il est nécessaire que les branches soient nommées de manière explicite. On peut classer les branches avec des dossiers en les nommant de la manière suivante: `dossier/branche`. Le nom de dossier peut reprendre la typologie suivante:

-   `fonc`: ajout, suppression ou modification d'une fonctionnalité;

-   `fix`: correction de bug;

-   `doc`: ajout, modification de la documentation;

-   `code`: modification du code sans alteration des fonctionnalités (refactorisation): pour amélioration de performance, de lisibilité...

Le nom de la branche précise alors, de manière synthétique, la modification apportée.

#### Proposition d'intégration des modifications dans le dépôt de référence

Les modifications ainsi réalisées sur le dépôt d'un contributeur sont proposées pour intégration dans la branche `dev` du dépôt de référence via le mécanisme de *Pull request*. Le nom et la description de la proposition doivent être suffisamment explicite pour que les contributeurs principaux puissent savoir de quoi il retourne sans avoir à regarder en détail les modifications apportées au code et aux fichiers du dépôt. Une fois la proposition intégrée à la branche `dev` du dépôt de référence, la branche d'origine sur le dépôt du contributeur peut être supprimée s'il le souhaite. La branche `dev` des dépôts dupliqués doit alors être mise à jour en la synchronisant avec celle du dépôt de référence.

Une fois les modifications testées sur la branche `dev` et éventuellement complétées par d'autres modifications, elles sont intégrées dans la branche principale du dépôt de référence et sont ainsi prêtes à être déployées sur les dépôts des différentes déclinaisons régionales de l'outil.

### Suivi des modifications

Chaque proposition de modification portée sur une branche de développement peut être assez complexe et impliquer de nombreuses lignes de codes réparties dans plusieurs fichiers.

Pour faciliter sa compréhension, il convient que les modifications ne soient pas toutes concentrées dans un seul enregistrement ([commit](https://docs.github.com/fr/pull-requests/committing-changes-to-your-project/creating-and-editing-commits/about-commits)) mais détaillées dans plusieurs enregistrements ne concernant qu'une part plus réduite et cohérente du code.

Le nom des commits et leur description doivent permettre de comprendre quel changement a été fait et dans quelle finalité.

## ⚠️ Précautions

Lors de la déclinaison régionale et ensuite lors des mises-à-jours automatiques certains fichiers sont modifiés manuellement ou automatiquement sur les branches `master` et `deploy` des dépôts dupliqués.

**La modification de ces fichiers sur le dépôt de référence entrainera donc l'échec des mises-à-jours automatiques des déclinaisons régionalisées depuis le dépôt de référence.**

**Ces fichiers ne doivent donc être modifiés sur la branche principale du dépôt de référence que si cela est nécessaire pour ajouter une nouvelle fonctionnalité ou résoudre un problème.**

Lorsque ces fichiers sont modifiés et que la mise-à-jour automatique échoue, il convient soit de [**résoudre manuellement les conflits**](https://docs.github.com/fr/pull-requests/collaborating-with-pull-requests/addressing-merge-conflicts/resolving-a-merge-conflict-on-github), soit de [**supprimer le dépôt dupliqué**](https://github.com/richaben/PRR_ONDE/blob/master/Install.md#d%C3%A9sinstallation-de-loutil) **et de [refaire une copie](https://github.com/richaben/PRR_ONDE/blob/master/Install.md#installation-de-loutil) à partir de la dernière version du dépôt de référence**.

Les fichiers concernés sont:

-   `_config.R`

-   `index.html`

-   `data/onde_data`

-   `data/processed_data`

#### 
