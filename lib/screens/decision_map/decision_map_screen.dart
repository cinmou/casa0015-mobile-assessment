import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_oracle/l10n/app_localizations.dart';
import 'package:the_oracle/services/firestore_service.dart';
import 'package:the_oracle/models/decision_node.dart';
import 'package:the_oracle/services/image_service.dart';
import 'package:the_oracle/widgets/decision_node_card.dart';

// Enum to represent the user's choice in the image dialog
enum ImageAction { camera, gallery, delete }

class DecisionMapScreen extends StatefulWidget {
  const DecisionMapScreen({super.key});

  @override
  State<DecisionMapScreen> createState() => _DecisionMapScreenState();
}

class _DecisionMapScreenState extends State<DecisionMapScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final ImageService _imageService = ImageService();

  // Function to handle picking, replacing, or deleting an image for a node
  Future<void> _handleImageAction(DecisionNode node) async {
    final l10n = AppLocalizations.of(context)!;
    final bool imageExists = node.imagePath != null && node.imagePath!.isNotEmpty;

    // Show a dialog to choose the action
    final ImageAction? action = await showDialog<ImageAction>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addImage),
        content: Text(l10n.addImageSource),
        actions: [
          TextButton(
            child: Text(l10n.camera),
            onPressed: () => Navigator.pop(context, ImageAction.camera),
          ),
          TextButton(
            child: Text(l10n.gallery),
            onPressed: () => Navigator.pop(context, ImageAction.gallery),
          ),
          // Only show the delete button if an image already exists
          if (imageExists)
            TextButton(
              child: Text(
                l10n.deleteImage, // Assuming 'deleteImage' will be added to l10n
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onPressed: () => Navigator.pop(context, ImageAction.delete),
            ),
        ],
      ),
    );

    if (action == null) return; // User cancelled

    switch (action) {
      case ImageAction.camera:
      case ImageAction.gallery:
        final source = action == ImageAction.camera ? ImageSource.camera : ImageSource.gallery;
        final String? newImagePath = await _imageService.pickAndSaveImage(source: source);

        if (newImagePath != null) {
          // If there was an old image, delete it first
          if (imageExists) {
            await _imageService.deleteImage(node.imagePath);
          }
          // Update the node with the new image path
          final updatedNode = node.copyWith(imagePath: newImagePath);
          await _firestoreService.updateDecision(updatedNode);
        }
        break;
      case ImageAction.delete:
        // Delete the image and update the node
        await _imageService.deleteImage(node.imagePath);
        final updatedNode = node.copyWith(imagePath: null); // Set imagePath to null
        await _firestoreService.updateDecision(updatedNode);
        break;
    }
  }

  // Function to show the edit/delete options
  void _showDecisionOptions(BuildContext context, DecisionNode node) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.edit),
                title: Text(l10n.edit),
                onTap: () {
                  Navigator.pop(bc);
                  _showEditDecisionDialog(context, node);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: Text(l10n.delete),
                onTap: () {
                  Navigator.pop(bc);
                  _confirmDeleteDecision(context, node);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to show the edit dialog
  void _showEditDecisionDialog(BuildContext context, DecisionNode node) {
    final l10n = AppLocalizations.of(context)!;
    final TextEditingController questionController = TextEditingController(text: node.question);
    final TextEditingController moodController = TextEditingController(text: node.mood);
    final TextEditingController solutionController = TextEditingController(text: node.solution);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.editDecision),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: questionController,
                  decoration: InputDecoration(labelText: l10n.question),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: moodController,
                  decoration: InputDecoration(labelText: l10n.saveToMapMood),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: solutionController,
                  decoration: InputDecoration(labelText: l10n.saveToMapSolutionHint),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.cancel),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text(l10n.save),
              onPressed: () async {
                final updatedNode = node.copyWith(
                  question: questionController.text,
                  mood: moodController.text,
                  solution: solutionController.text,
                );
                await _firestoreService.updateDecision(updatedNode);
                if (mounted) {
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.savedToMapSuccess)),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Function to confirm deletion of the entire node
  void _confirmDeleteDecision(BuildContext context, DecisionNode node) async {
    final l10n = AppLocalizations.of(context)!;
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.deleteRecord),
          content: Text(l10n.deleteRecordConfirmation(node.question)),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.cancel),
              onPressed: () => Navigator.of(dialogContext).pop(false),
            ),
            TextButton(
              child: Text(l10n.delete),
              onPressed: () => Navigator.of(dialogContext).pop(true),
            ),
          ],
        );
      },
    );

    if (confirm == true && node.id != null) {
      // Delete the associated image first
      await _imageService.deleteImage(node.imagePath);
      // Then delete the Firestore record
      await _firestoreService.deleteDecision(node.id!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.recordDeleted)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.bottomNavMap),
      ),
      body: StreamBuilder<List<DecisionNode>>(
        stream: _firestoreService.getDecisionsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.decisionMapScreenTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(l10n.noDecisionsYet),
                ],
              ),
            );
          }

          final decisions = snapshot.data!;

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: decisions.length,
            itemBuilder: (context, index) {
              final node = decisions[index];
              return DecisionNodeCard(
                node: node,
                onLongPress: () => _showDecisionOptions(context, node),
                onAddImage: () => _handleImageAction(node),
              );
            },
          );
        },
      ),
    );
  }
}
