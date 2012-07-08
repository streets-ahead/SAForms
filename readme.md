#Streets Ahead Forms

I've been developing for iOS for a while now and I very often find myself needing to create forms.  The classic way to create forms on iOS is to use a UITableViewController.  The problem is that always seemed messy to me, you go in and create a new UITableViewController, it will have a ton of boilerplate code all over, and you end up jumping around because you have to go over here to change the number of sections, then go over here to change the cell type for row and sections, etc.  Now obviously there are some tricks that we can use to make these things easier and more organized.  There are also some existing frameworks like [QuickDialog](https://github.com/escoz/QuickDialog/), which is a solid framework, certainly more developed than what I am going to show here.  Anyway, I wanted to create something that worked exactly the way I wanted it to, so I took a few hours and built out this little framework.  

In its current state it is very experimental / alpha, there are a lot of places where I'm still trying to decide on the best way to do things.  I have put a handful of hours  into the framework, and then spent a few more hours trying to build a real app with it, so I've already found a lot of issues and had to tweak things here and there.  There are no promises that I'll have time to continue development of this either, even though I would like to and currently that is my intention.  Anyway, feel free to use this, learn from it, criticize  it, etc.  Absolutely feel free to fork away I'd be happy to have some pull requests.  Also if you like what you see around here check out our [blog](http://streetsaheadllc.com).

Everything here is under the [MIT Liscenc](http://www.opensource.org/licenses/mit-license.php/).