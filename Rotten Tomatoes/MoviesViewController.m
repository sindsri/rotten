//
//  MoviesViewController.m
//  Rotten Tomatoes
//
//  Created by sindhuja sridharan on 9/17/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"

@interface MoviesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;
@property UIRefreshControl *refreshControl;

@end

@implementation MoviesViewController{
    //UIRefreshControl*_refreshControl;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Movies";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 125;
    
    
    //IntialRefresh
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refresh"];
    [refreshControl addTarget:self action:@selector(refresh:)forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=us";
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
        
        if(!connectionError) {
            NSDictionary *object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.movies = object[@"movies"];
            [self.tableView reloadData];
            //NSLog(@"movies: %@", self.movies);

        } else {
            //display an error alert
        }
        
    }];
    NSLog(@"finished with View did Load");
}

-(NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog(@"index path: %d", indexPath.row);
    
    NSDictionary *movie = self.movies[indexPath.row];
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"synopsis"];
    NSString *posterUrl = [movie valueForKeyPath:@"posters.thumbnail"];
    [cell.posterView setImageWithURL:[NSURL URLWithString:posterUrl]];
    
    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
  
    // Dispose of any resources that can be recreated.
}
-(void)refresh:(UIRefreshControl *)refreshControl {
    [self.tableView reloadData];
    [refreshControl endRefreshing];

}

@end
