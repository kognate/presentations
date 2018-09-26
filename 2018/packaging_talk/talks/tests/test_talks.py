from talks import Talk
from unittest import TestCase

class TestTalk(TestCase):

    def setUp(self):
        self.talk = Talk()

    def test_thank(self):
        self.assertEqual(self.talk.thank(), "Thanks!")

    def test_crowd(self):
        self.assertEqual(self.talk.thank(crowd="me"), "Thanks for coming to me")

    def test_speaker(self):
        self.assertEqual(self.talk.thank(speaker="me"), "Thanks you me for giving this talk")
