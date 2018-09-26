class Talk:

    def thank(self,
              speaker=None,
              crowd=None):

        payload = 'Thanks!'
        
        if crowd:
            payload = f'Thanks for coming to {crowd}'
        if speaker:
            payload = f'Thanks you {speaker} for giving this talk'

        print(payload)
        return payload

