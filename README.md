## Example

This is an example of posting a message from the top of the window:

    UIApplication.shared.postView.post(badgeMessage:
        BadgeMessage(
            title: "This is a window notification",
            subtitle: "This notification has been posted on the key window",
            image: UIImage(named: "donations"),
            fillColor: .red
        )
    )
    
![Alt Text](https://github.com/3sidedcube/MessageStackView/blob/develop/Documentation/toastGif.gif)

Here:
1. The `badgeMessage` model defines what the message should look like
2. A `BadgeMessageView` is created with properties defined by the `badgeMessage`
3. The `BadgeMessageView` is posted on a `PostView` on the key window

## Core Entities

### PostManager

Encaspsulates the logic of when and how `UIView`s should be posted and removed.

Internally `PostManager` handles:
1. Dismissal `Timer`s which, after a given time, request to remove a previously posted `UIView`
2. A `PostGestureManager` for gesture related dismissals, e.g. pan.
3. Serial `Queue` if required

### UIViewPoster

While `PostManager` handles the logic of when to post and remove a `UIView`, `UIViewPoster` handles the actual posting and subviews.
Specifically, adding and removing the subview to the subview hierarchy, and animating when required.

`PostManager` references a `UIViewPoster` communicating when to post and remove.
There are a few common implementations of `UIViewPoster` provided in this framwork.

### PostView

A `UIView` for posting other `UIView`s in a serial manner.
The animation of posted `UIView`s is via a `translation` from the top.

Commonly, `PostView` is constrained to the top, leading, trailing edges of a `UIView` e.g. `UIWindow`.
When a subview is posted, the `PostView` constrains its edges to the added subview.
So, in this case, a posted `UIView` would define its height either intrinsically or via explicit constraints, with its width determined by the `PostView`.

### MessageStackView

A simple wrapper of a vertical `UIStackView` for posting and removing `UIView`s.
These `UIView`s, being a `UIStackView`, are part of the `arrangedSubviews`.
The animation of posted `UIView`s is handled via the `UIStackView` by setting `isHidden`.

## Usage

There is an Example project in the repository, but a simple use case would be:  

    class ViewController: UIViewController {
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            // A `PostView` is created on the `UIViewController` instance if required
            postViewOrCreate().post(message: Message(
                title: "Message Title",
                subtitle: "This is message subtitle for detail",
                leftImage: .information,
                rightImage: nil
            ))
        }
    }
    
## Models

### Message

Properties include:  
1. `title` -  required  
2. `subtitle` -  Optional  
3. `leftImage` - Optional  
3. `rightImage` - Optional  

A `Message` describes how a `MessageView` should look, which is the view which is posted on the `UIViewPoster`.

### BadgeMessage

`BadgeMessage` is similar to `Message` with an updated design and interface.

## Other

### MessageStackView + Custom View
  
The posted `UIView`s width will be determined by the `UIStackView` as the `distribution` is `fill` and the `UIStackView` axis is `.vertical`.  
However the height of the `UIView` is driven by the `UIView` itself, e.g. autolayout.  
  
If, when posting and removing this `UIView` from the `MessageStackView` you want the animation to be smooth, then consider a "breakable" constraint for the height. Since the `UIStackView` will animate the `isHidden` property on the `UIView`, which will set an explict height during animation.
