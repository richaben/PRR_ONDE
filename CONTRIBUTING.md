# Contribution au PPR ONDE

## Dépôt de référence

Le dépôt de référence du projet est hébergé sur Github: <https://github.com/richaben/PRR_ONDE>. Les mises-à-jour du code de l'application doivent d'abord être intégrées dans la branche principale de dépôt pour être accessibles aux différentes déclinaisons régionales de l'outil (voir [ici pour la procédure d'installation](https://github.com/richaben/PRR_ONDE/blob/master/Install.md#installation-de-loutil)).

Ce document décrit les grands principes permettant de structurer les contributions à l'outil via ce dépôt référence. Ces contributions nécessitent de disposer d'un compte GitHub.

## Tickets

Les signalements de bug, demandes de corrections ou d'évolutions doivent être remontés via [l'outil Issues du dépôt de référence](https://github.com/richaben/PRR_ONDE/issues),.

Afin de faciliter le traitement de ces demandes, il est recommandé d'être **le plus précis possible** dans la description des problèmes rencontrés ou des évolutions demandées. Des captures d'écran peuvent être utilement mises à contribution.

Il est également recomandé de **lire les tickets déjà ouverts afin de vérifier que le problème rencontré n'a pas déjà été signalé**. Si le problème est le même, il est préférable de compléter sa description, de signaler qu'il est observé par d'autres dans le ticket d'origine plutôt que d'en ouvrir un nouveau.

Les contributeurs au dépôt de référence peuvent attribuer des étiquettes *(labels)* aux tickets ouverts afin de les classer dans plusieurs catégories, dont :

-   **bug**: signalement d'erreurs ou de mauvais fonctionnement;

-   **enhancement**: proposition d'amélioration de l'application (ergonomie, fonctionnalité...)

-   **documentation**: besoin d'ajout ou de précision dans la documentation

## Contribution au code

Il est également possible de contribuer à l'amélioration de l'outil plus directement via des modifications du code et de la documentation.

Afin de faciliter le travail d'intégration de ces contributions, un certain nombre de recommendations sont nécessaires.

### Principe

Le travail de développement ne se fait pas directement sur le dépôt de référence mais sur des copies ([fork](https://docs.github.com/fr/pull-requests/collaborating-with-pull-requests/working-with-forks/about-forks)) de ce dépôt par les contributeurs, ce qui leur permet de tester les modifications et ajouts proposées sans risque d'impacter le dépôt de référence.

Les propositions de modifications sont ensuite proposées ([Pull request](https://docs.github.com/fr/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests)) au dépôt de référence dont les contributeurs principaux évalueront la pertinence et la faisabilité de leur intégration.

### Branches

Un dépôt peut contenir plusieurs lignes de développement en parallèle, ce que l'on appelle des [branches](https://docs.github.com/fr/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-branches). Les modifications apportées dans une branche n'affectent pas le code des autres branches.

#### Le dépôt de référence

Le dépôt de référence du PRR Onde est composé de trois branches:

-   **`master`**: c'est la branche principale, celle qui retrace l'historique des modifications du code de l'application. Il est souhaité que l'historique de cette branche soit le plus propre possible afin de faciliter sa lecture et de **visualiser rapidement les principales étapes et évolutions du code**. **Cette branche ne doit pas être modifiée directement**;

-   **`deploy`**: il s'agit d'une copie de la branche principale qui récupère automatiquement les modifications apportées à cette dernière. C'est également sur cette branche que sont effectuées automatiquement les mise-à-jour des données et le déploiement de la page HTML générée. **Cette branche ne doit pas être modifiée manuellement**;

-   **`dev`**: il s'agit de la branche de travail sur laquelle vont **être enregistrées toutes les modifications du code**. Afin de faciliter le travail collaboratif, **l'idéal est de ne pas travailler directement sur cette branche mais d'y intégrer les propositions de modification des collaborateurs en utilisant des Pull requests**. Une fois un certain nombre de modifications intégrées et testées dans dev, il convient alors de les intégrer dans la branche principale.

#### Les dépôts dupliqués des contributeurs

En plus des trois branches mentionnées pour le dépôt de référence, les dépôts des contributeurs, sur lesquels sont fait les travaux de développement, vont contenir des branches supplémentaires. Ces branches vont servir à enregistrer les modifications du code proposées pour intégration dans le dépôt de référence. Chaque branche est créée à partir de la branche `dev` et **correspond à une proposition de modification spécifique** (ajout d'une fonctionnalité, correction d'un bug, ajout/modification de documentation...).

#### Règles de nommage

Afin de faciliter le suivi des propositions de modification, il est nécessaire que les branches soient nommées de manière explicite. On peut classer les branches avec des dossiers en les nommant de la manière suivante: `dossier/branche`. Le nom de dossier peut reprendre la typologie suivante:

-   `fonc`: ajout, suppression ou modification d'une fonctionnalité;

-   `fix`: correction de bug;

-   `doc`: ajout, modification de la documentation;

-   `code`: modification du code sans alteration des fonctionnalités (refactorisation): pour amélioration de performance, de lisibilité...

Le nom de la branche précise alors, de manière synthétique, la modification apportée.

#### Principes d'intégration
