import 'dart:math';

class PetMessages {
  static final List<String> _messages = [
    'Your furry friends deserve the best',
    'Pamper your pets with love and care',
    'Where every paw is treated like royalty',
    'Because pets are family too',
    'Happy tails start here',
    'Comfort for your companions',
    'Keeping your pets healthy and happy',
    'Gentle hands for gentle paws',
    'Bringing joy to your pets’ lives',
    'We love your pets like you do',
    'Quality care for your four-legged friends',
    'Safe and fun pet experiences',
    'Tail wags guaranteed',
    'A home away from home for your pets',
    'Trusted by pet parents everywhere',
    'Where pets feel at ease',
    'More cuddles, more care',
    'Smiles and wagging tails all day',
    'Expert care for your precious pets',
    'Because every pet is special',
  ];

  static final List<String> _funFacts = [
    'A dog’s nose print is as unique as a human fingerprint.',
    'Cats can rotate their ears 180 degrees.',
    'Goldfish have a memory span of at least three months.',
    'Dogs have about 1,700 taste buds, humans have about 9,000.',
    'A group of kittens is called a kindle.',
    'Rabbits can turn their ears 180 degrees to pinpoint sounds.',
    'Guinea pigs "popcorn" when they are happy, jumping up and down.',
    'Parrots can live over 80 years.',
    'A cat spends about 70% of its life sleeping.',
    'Ferrets sleep for 18 hours a day.',
    'Horses can sleep both lying down and standing up.',
    'Hamsters’ teeth never stop growing.',
    'Cows have best friends and get stressed when separated.',
    'Dogs can learn over 1000 words and gestures.',
    'Butterflies taste with their feet.',
    'Octopuses have three hearts.',
    'A snail can sleep for three years.',
    'Bees communicate by dancing.',
    'Elephants are the only animals that can’t jump.',
    'Ostriches can run faster than horses.',
    'Frogs can freeze without dying.',
    'Some turtles can breathe through their butts.',
    'A newborn kangaroo is the size of a lima bean.',
    'Sea otters hold hands when they sleep to keep from drifting apart.',
    'Pigs are smarter than dogs and can learn video games.',
    'Sloths can hold their breath longer than dolphins.',
    'Crows can recognize human faces.',
    'Camels have three eyelids to protect against sand.',
    'Dolphins call each other by name.',
    'Ants can carry 50 times their body weight.',
    'Flamingos are born gray, not pink.',
    'Male seahorses carry the babies.',
    'Penguins propose with pebbles.',
    'Goats have rectangular pupils.',
    'Some lizards can squirt blood from their eyes.',
    'Koalas sleep up to 22 hours a day.',
    'Owls can rotate their heads almost all the way around.',
    'Chameleons’ tongues can be twice the length of their body.',
    'Tarantulas can survive over two years without food.',
    'Butterflies remember things they learned as caterpillars.',
    'Rats laugh when tickled.',
    'Kangaroos can’t walk backward.',
    'Cows have almost 300 degrees of vision.',
    'Polar bears have black skin under their white fur.',
    'Dogs’ sense of smell is 40 times better than humans.',
    'Cats can make over 100 different sounds.',
    'Bats are the only mammals that can fly.',
    'Giraffes have no vocal cords.',
    'Walruses can sleep while floating in water.',
  ];

  static String getRandomPetMessage() {
    final random = Random();
    return _messages[random.nextInt(_messages.length)];
  }

  static String getRandomFunFact() {
    final random = Random();
    return _funFacts[random.nextInt(_funFacts.length)];
  }
}
