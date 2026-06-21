import 'package:flutter/material.dart';
import '../screens/premium_screen.dart';
import '../screens/register_screen.dart';

void showPremiumInviteDialog(BuildContext context, {required bool isLoggedIn}) {
  final theme = Theme.of(context);
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            const Icon(Icons.stars, color: Colors.amber, size: 28),
            const SizedBox(width: 8),
            const Text(
              'PRO',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          isLoggedIn
              ? 'Para poder filtrar las oportunidades por facturación, sector, región y número de empleados, necesitas una cuenta Premium de Relevo.'
              : 'Para poder filtrar y buscar oportunidades avanzadas, necesitas registrarte e iniciar sesión en Relevo.',
          style: const TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              if (isLoggedIn) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PremiumScreen()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                );
              }
            },
            child: Text(isLoggedIn ? 'Hacerse PRO' : 'Registrarse'),
          ),
        ],
      );
    },
  );
}
