

# Pixabay Gallery


![image](https://github.com/user-attachments/assets/cac73077-1984-4643-9483-06932ac2f451)



## Live Deployment

🔗 **[Pixabay Gallery Live](https://pixabaygallery.vercel.app/)**

## Overview

**Pixabay Gallery** is a Flutter-based application showcasing a gallery of images sourced from the Pixabay API. The app features a responsive grid layout, ensuring a smooth user experience across different device sizes, and supports infinite scrolling to load additional images seamlessly. Each image displays the number of likes and views.

## Features

- **Image Gallery**: Explore a variety of images fetched from the Pixabay API.
- **Responsive Grid Layout**: The staggered grid adjusts automatically to different screen sizes.
- **Infinite Scroll**: New images are dynamically loaded as you scroll to the bottom of the gallery.
- **Image Details**: View the likes and views for each image below the thumbnail.

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)
- A code editor (e.g., VS Code or Android Studio)

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/jnvshubham7/pixabay_gallery.git
   ```

2. Navigate to the project folder:

   ```bash
   cd pixabay_gallery
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Launch the application:

   ```bash
   flutter run
   ```

### Configuration

- **Pixabay API Key**: Update the `_fetchImages` method with your Pixabay API key. You can obtain a key by signing up at [Pixabay API](https://pixabay.com/api/docs/).

### Web Deployment

To deploy the app on GitHub Pages:

1. Build the web version:

   ```bash
   flutter build web
   ```

2. Follow the [GitHub Pages guide](https://docs.github.com/en/pages) to publish the `build/web` folder.

## Usage

Once the app is running, scroll through the image gallery. New images will load automatically as you reach the bottom of the screen.

## Contributing

Contributions are welcome! Here's how you can contribute:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/YourFeature`).
3. Make your changes and commit (`git commit -m 'Add new feature'`).
4. Push your branch (`git push origin feature/YourFeature`).
5. Open a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.

## Acknowledgments

- [Pixabay API](https://pixabay.com/api/docs/) for image data.
- [Flutter](https://flutter.dev/) for the framework.
- [flutter_staggered_grid_view](https://pub.dev/packages/flutter_staggered_grid_view) for the grid layout.
