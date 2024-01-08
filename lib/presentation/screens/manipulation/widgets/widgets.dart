import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rpe_c/presentation/screens/manipulation/widgets/models.dart';

// Cluster widget
class ManipulationCluster extends StatefulWidget {
  const ManipulationCluster({
    super.key,
    required this.customer,
    this.highlighted = false,
    this.hasItems = false,
  });

  final ActiveArea customer;
  final bool highlighted;
  final bool hasItems;

  @override
  State<ManipulationCluster> createState() => _ManipulationClusterState();
}

class _ManipulationClusterState extends State<ManipulationCluster> {
  Widget addSlidableWidget(name, index) {
    return Slidable(
      key: ValueKey(index + 1),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (BuildContext context) {
              setState(() {
                widget.customer.items.removeAt(index);
              });
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),

      // The child of the Slidable is what the user sees when the
      // component is not dragged.
      child: ListTile(title: Text(name)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.highlighted ? Colors.white : Colors.black;

    return Transform.scale(
      scale: widget.highlighted ? 1.075 : 1.0,
      child: Material(
        elevation: widget.highlighted ? 8 : 4,
        borderRadius: BorderRadius.circular(22),
        color: widget.highlighted ? const Color(0xFFF64209) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.7,
            width: MediaQuery.sizeOf(context).width * 0.3,
            child: ListView.builder(
              itemCount: widget.customer.items.length,
              itemBuilder: (BuildContext context, int index) {
                return addSlidableWidget(
                    widget.customer.items[index].name, index);
              },
            ),
          ),
        ),
      ),
    );
  }
}

//association widget
class ManipulationAssociations extends StatefulWidget {
  final VoidCallback function;

  const ManipulationAssociations({
    super.key,
    required this.customer,
    this.highlighted = false,
    this.hasItems = false,
    required this.function,
  });

  final ActiveArea customer;
  final bool highlighted;
  final bool hasItems;

  @override
  State<ManipulationAssociations> createState() => _ManipulationAssociations();
}

class _ManipulationAssociations extends State<ManipulationAssociations> {
  Widget addSlidableWidget(name, index) {
    return Column(
      children: [
        Slidable(
          key: ValueKey(index + 1),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (BuildContext context) {
                  setState(() {
                    print(widget.customer.size);
                    widget.customer.items.removeAt(index);
                    if (widget.customer.items.length * 150 < 150) {
                      widget.customer.size = 150;
                    } else {
                      widget.customer.size = widget.customer.items.length * 150;
                    }

                    widget.function();
                  });
                },
                backgroundColor: const Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),

          // The child of the Slidable is what the user sees when the
          // component is not dragged.
          child: ListTile(title: Text(name)),
        ),
        Slider(
          value: 0.5,
          // The initial value of the slider
          min: 0,
          // The minimum value of the slider
          max: 1,
          // The maximum value of the slider
          divisions: 10,
          // The number of divisions on the slider
          onChanged: (double value) {
            // This callback is called whenever the slider value changes
            // Use the value parameter to update your application state
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.highlighted ? Colors.white : Colors.black;

    return Transform.scale(
      scale: widget.highlighted ? 1.075 : 1.0,
      child: Material(
        elevation: widget.highlighted ? 8 : 4,
        borderRadius: BorderRadius.circular(22),
        color: widget.highlighted ? const Color(0xFFF64209) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.7,
            width: MediaQuery.sizeOf(context).width * 0.3,
            child: ListView.builder(
              itemCount: widget.customer.items.length,
              itemBuilder: (BuildContext context, int index) {
                return addSlidableWidget(
                    widget.customer.items[index].name, index);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class DeviceListItem extends StatelessWidget {
  const DeviceListItem({
    super.key,
    this.name = '',
    this.price = '',
    required this.photoProvider,
    this.isDepressed = false,
  });

  final String name;
  final String price;
  final ImageProvider photoProvider;
  final bool isDepressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12,
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        width: 50,
        height: 100,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 50,
                height: 50,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeInOut,
                    height: isDepressed ? 50 : 70,
                    width: isDepressed ? 50 : 70,
                    child: Image(
                      image: photoProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 30),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 18,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DraggingListItem extends StatelessWidget {
  const DraggingListItem({
    super.key,
    required this.dragKey,
    required this.photoProvider,
  });

  final GlobalKey dragKey;
  final ImageProvider photoProvider;

  @override
  Widget build(BuildContext context) {
    return FractionalTranslation(
      translation: const Offset(-0.5, -0.5),
      child: ClipRRect(
        key: dragKey,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 150,
          width: 150,
          child: Opacity(
            opacity: 0.85,
            child: Image(
              image: photoProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

Widget sliderWidget() {
  return Text("aaaa");
}
