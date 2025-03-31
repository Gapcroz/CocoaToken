import 'package:flutter/material.dart';
import '../models/event.dart';

class ExpandableEventSection extends StatelessWidget {
  final EventCategory category;
  final bool isExpanded;
  final VoidCallback onToggle;

  // Constantes para evitar recreaciones
  static const _animationDuration = Duration(milliseconds: 300);
  static const _borderRadius = BorderRadius.all(Radius.circular(25));
  static const _headerPadding = EdgeInsets.symmetric(
    horizontal: 25,
    vertical: 14,
  );
  static const _contentMargin = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  );

  const ExpandableEventSection({
    super.key,
    required this.category,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [_buildHeader(), _buildExpandableContent()]);
  }

  Widget _buildHeader() {
    return Padding(
      padding: _contentMargin,
      child: Material(
        color: Colors.grey.shade200,
        borderRadius: _borderRadius,
        child: InkWell(
          onTap: onToggle,
          borderRadius: _borderRadius,
          child: Padding(
            padding: _headerPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  category.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                AnimatedRotation(
                  turns: isExpanded ? 0.25 : 0,
                  duration: _animationDuration,
                  child: const Icon(
                    Icons.keyboard_arrow_right,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableContent() {
    return AnimatedContainer(
      duration: _animationDuration,
      curve: Curves.easeInOut,
      height: isExpanded ? (category.events.length * 120.0) : 0,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children:
              isExpanded
                  ? category.events
                      .map((event) => _EventCard(event: event))
                      .toList()
                  : [],
        ),
      ),
    );
  }
}

// Separar el EventCard en un widget independiente para mejor rendimiento
class _EventCard extends StatelessWidget {
  final Event event;

  static const _imageSize = 100.0;
  static const _cardMargin = EdgeInsets.symmetric(horizontal: 16, vertical: 8);

  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: _cardMargin,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            const SizedBox(width: 12),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: _imageSize,
        height: _imageSize,
        color: Colors.grey.shade200,
        child: const Icon(
          Icons.image_not_supported_outlined,
          size: 32,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          event.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          event.description,
          style: const TextStyle(fontSize: 12, color: Color(0xFF111827)),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (event.hasReward) ...[
          const SizedBox(height: 10),
          _buildRewardInfo(),
        ],
      ],
    );
  }

  Widget _buildRewardInfo() {
    return Row(
      children: [
        const _RewardLabel(),
        const SizedBox(width: 10),
        _RewardAmount(tokens: event.rewardTokens),
      ],
    );
  }
}

// Widgets pequeños y reutilizables
class _RewardLabel extends StatelessWidget {
  const _RewardLabel();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.card_giftcard, color: Colors.black87, size: 14),
        SizedBox(width: 4),
        Text(
          'Recompensa',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _RewardAmount extends StatelessWidget {
  final int tokens;

  const _RewardAmount({required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.monetization_on, color: Color(0xFFD4A373), size: 14),
        const SizedBox(width: 4),
        Text(
          '$tokens CocoaTokens',
          style: const TextStyle(
            color: Color(0xFFD4A373),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
