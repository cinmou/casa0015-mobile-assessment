import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_oracle/models/decision_node.dart';
import 'package:the_oracle/l10n/app_localizations.dart';
import 'package:the_oracle/screens/decision_map/full_screen_image_screen.dart'; // Import the new screen

class DecisionNodeCard extends StatelessWidget {
  final DecisionNode node;
  final VoidCallback? onLongPress;
  final VoidCallback? onAddImage; // Callback for adding/changing image

  const DecisionNodeCard({
    super.key,
    required this.node,
    this.onLongPress,
    this.onAddImage,
  });

  // Helper to get a weather icon
  IconData _getWeatherIcon(String? condition) {
    switch (condition?.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.grain;
      case 'snow':
        return Icons.ac_unit;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'drizzle':
        return Icons.cloudy_snowing;
      case 'fog':
      case 'mist':
      case 'haze':
        return Icons.foggy;
      default:
        return Icons.thermostat_outlined;
    }
  }

  // Helper to get a tool icon
  IconData _getToolIcon(String tool) {
    switch (tool.toLowerCase()) {
      case 'coin':
      case 'coin flip':
        return Icons.monetization_on;
      case 'tarot':
      case 'tarot draw':
        return Icons.auto_stories;
      case 'dice':
      case 'dice roll':
        return Icons.casino;
      case 'fortune stick':
        return Icons.straighten;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    String locationString = (node.latitude != null && node.longitude != null)
        ? '${node.latitude!.toStringAsFixed(2)}, ${node.longitude!.toStringAsFixed(2)}'
        : l10n.unknownLocation;

    return GestureDetector(
      onLongPress: onLongPress,
      child: Card(
        clipBehavior: Clip.antiAlias, // Prevents overflow
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        elevation: 4.0,
        child: Container(
          width: 200,
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question
                  Text(
                    l10n.question,
                    style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    node.question,
                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12.0),

                  // Image display (square, below question)
                  if (node.imagePath != null && node.imagePath!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenImageScreen(imagePath: node.imagePath!),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: AspectRatio(
                            aspectRatio: 1.0, // Square aspect ratio
                            child: Hero(
                              tag: node.imagePath!, // Hero tag for animation
                              child: Image.file(
                                File(node.imagePath!),
                                fit: BoxFit.cover, // Center crop
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: Colors.grey[200],
                                  child: const Center(child: Icon(Icons.broken_image)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Tool Icon and Type
                  Row(
                    children: [
                      Icon(_getToolIcon(node.tool), color: theme.colorScheme.secondary, size: 20),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(node.tool, style: textTheme.bodyMedium, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),

                  // Result
                  Text(
                    '${l10n.result}: ${node.result}',
                    style: textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12.0),

                  // Weather and Temperature
                  Row(
                    children: [
                      Icon(_getWeatherIcon(node.weatherCondition), color: theme.colorScheme.primary, size: 20),
                      const SizedBox(width: 4.0),
                      if (node.temperature != null)
                        Text('${node.temperature!.toStringAsFixed(0)}°C', style: textTheme.bodySmall),
                      const Spacer(),
                      Text('${l10n.mood}: ${node.mood}', style: textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 8.0),

                  // Location
                  Text('${l10n.location}: $locationString', style: textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8.0),

                  // Solution
                  if (node.solution.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${l10n.solution}:', style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                        Text(node.solution, style: textTheme.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  const SizedBox(height: 40), // Space for the button
                ],
              ),

              // Add/Edit Image Button
              Positioned(
                bottom: -4,
                right: -4,
                child: IconButton(
                  icon: Icon(
                    node.imagePath != null && node.imagePath!.isNotEmpty
                        ? Icons.edit
                        : Icons.add_a_photo,
                    color: theme.colorScheme.primary,
                  ),
                  onPressed: onAddImage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
