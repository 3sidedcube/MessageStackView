## MessageStackView

A simple wrapper of a vertical `UIStackView` for posting and removing messages.  
The most simple case is posting a `Message`  `struct`, but custom `UIView`s are also supported.

### Usage

There is an Example project in the repository, but a simple use case would be:  

    class ViewController: UIViewController  
    {  
        /// `MessageManager` for posting `Message`s  
        private lazy var messageManager = MessageManager(layout: .top(view)) 
        
        /// Event method  
        private func onSomeEvent() {  
            messageManager.post(message: Message(  
                title: "This is a title",  
                subtitle: "This is a subtitle")  
        }  
    }

### MessageManager

This class is responsible for posting `Message`s and `UIView`s on a `MessageStackView`.  
The lifetime of these items is determined by the `MessageTime` specified on post.  
The layout of the `MessageStackView` is determined by the `MessageLayout` defined in the initializer.  

The `MessageManager` will look after all `Timer`s when a finite `MessageTime` is specified for dismissal of an item.  

### MessageTime

`enum` to specify when a `UIView` is dismissed from the `MessageStackView`:  
1. `.after(TimeInterval)` - dismiss after a given `TimeInterval` (seconds)  
2. `.never` - Once posted do not dismiss  

### MessageLayout

`enum` to specify the `MessageStackView` layout.  
It will constrain the `MessageStackView` differently depending on the `MessageLayout`.  
1. `.top(UIView)` - Add the `MessageStackView` to the safe top, safe leading, and safe width of the given `UIView`  
2. `.bottom(UIView)` - Add the `MessageStackView` to the safe bottom, safe leading, and safe width of the given `UIView`  
3. `.custom((MessageStackView) -> Void)` - Add the `MessageStackView` as a subview and define custom constraints.  

### Message

Properties include:  
1. `title` -  required  
2. `subtitle` -  Optional  
3. `image` - Optional  

These can be posted on the `MessageManager`.
A `Message` describes how a `MessageView` should look, which is the view which is posted on the `MessageStackView`.

### Custom View

The `MessageManager` supports custom `UIView`s.  
The `UIView`s width will be determined by the `UIStackView` as the `distribution` is `fill`.  
However the height of the `UIView` is driven by the `UIView` itself, e.g. autolayout.  
  
If, when posting and removing this `UIView` from the `MessageStackView` you want the animation to be smooth, then consider a "breakable" constraint for the height. Since the `UIStackView` will animate the `isHidden` property on the `UIView`, which will set an explict height during animation.

### MessageConfiguration

Property on the `MessageManager`, specify a custom look and feel of  `Message`s.  
