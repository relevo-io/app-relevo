# MÍNIM 2 PAULA

Como usuario, necesito disponer de un sistema de
mentoring con seguimiento de progreso y recibir alertas
personalizadas sobre nuevas ofertas según mis preferencias

# 1 SISTEMA DE MENTORING

Implementat a la app tota la lògica d'integració amb el backend, i implementació de la gestió d'estats amb riverpod.
s'ha modificat el dio_client.dart er injectar l'idioma que utilitza l'usuari registrat per cridar del backend els moduls i el seu contingut amb l'idioma preferent. aixi s'evita tenir que enviar els 3 idiomes. La gestio d'idiomes es fa al backend perque aixi tot el que es el contingut dels moduls de mentoring queden guardat a mongo DB.
Creació de les screens noves per la implementació del mentoring amb IA generativa (gemini 3.5 flash low) per tal d'anar més ràpid. Igualment s'ha revisat tot aquest codi generat de les screens per assegurar-me que segueix l'estructura de totes les altres screens i evitar repetir codi innecesari. Tot el que són textos d'idiomes també s'ha implementat amb ia generativa per tal de modificar els 3 idiomes alhora i no ferho de forma manual.



# 2 ALERTES DE PREFERÈNCIES D'OFERTES

Implementat tota la logica d'integració amb el bakend per la gestio d'alertes i notificacions per la preferencia d'ofertes.
Creació de noves screens amb l'ajuda d'IA generativa per accelerar el procés. Inclos el que es traducció de textos de les screens a diferents idiomes amb ia generativa per estalviar temps.

Faltaria a la secció de notificacions millorar les targetes per indicar la oferta exatcte d'inreres, el propietari, la informació detallada, i poder desde la bustia de notificacions interactuar amb la oferta.

